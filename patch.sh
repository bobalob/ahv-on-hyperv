#!/bin/bash

workingDir=$(pwd)

echo "unpacking iso"
mkdir "$workingDir/tmpdir"
mkdir "$workingDir/mntdir"
mkdir "$workingDir/output"
mkdir "$workingDir/tmpdir/ce-2020.09.16.iso"
sudo mkdir "$workingDir/mntdir/ce-2020.09.16"
sudo mount -t iso9660 -o loop "$workingDir/iso/ce-2020.09.16.iso" "$workingDir/mntdir/ce-2020.09.16"
cd "$workingDir/mntdir/ce-2020.09.16"
tar cf - . | (cd "$workingDir/tmpdir/ce-2020.09.16.iso"; tar xfp -)
cd "$workingDir"

echo "unpacking initrd"
mkdir "$workingDir/tmpdir/initrd"
cd "$workingDir/tmpdir/initrd"
zcat "$workingDir/mntdir/ce-2020.09.16/boot/initrd" | cpio -ivd

echo "patching scripts"
grep -R "/sys/devices/pci" .
find . -type f -iname "*.py" -exec sed -i 's/\/sys\/devices\/pci/\/sys\/devices\/LNXSYSTM/g' "{}" +;
grep -R "/sys/devices/LNXSYSTM" .

echo "packing initrd"
mkdir "$workingDir/tmpdir/initrd-packed"
find . | cpio -o -H newc > "$workingDir/tmpdir/initrd-packed/initrd"
cd "$workingDir/tmpdir/initrd-packed"
gzip -9 initrd
mv initrd.gz initrd
cd $workingDir

echo "packing iso"
rm "$workingDir/tmpdir/ce-2020.09.16.iso/boot/initrd"
cp "$workingDir/tmpdir/initrd-packed/initrd" "$workingDir/tmpdir/ce-2020.09.16.iso/boot"
cd "$workingDir/tmpdir/ce-2020.09.16.iso"
mkisofs -o "$workingDir/output/ce-2020.09.16-hv-mkiso.iso" -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -R -V "PHOENIX" .

sudo umount "$workingDir/mntdir/ce-2020.09.16"
cd $workingDir
rm -rf ./tmpdir
rm -rf ./mntdir

echo "done"
ls -al "$workingDir/output"

echo "attempting boot test"
if ! command -v qemu-system-x86_64 &> /dev/null
then
    echo "qemu-system-x86_64 could not be found"
    exit
else
    qemu-system-x86_64 -boot d -cdrom ./output/ce-2020.09.16-hv-mkiso.iso -m 2048
fi

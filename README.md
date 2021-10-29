# ahv-on-hyperv

Script to patch the public ce-2020.09.16.iso to run in a Hyper-V guest VM

Start by [downloading the ce-2020.09.16.iso](https://next.nutanix.com/discussion-forum-14/download-community-edition-38417) from the Nutanix Community Edition forum (Requires Registration.)

Patch the iso using [the script](https://github.com/bobalob/ahv-on-hyperv). I used a fresh, temporary Ubuntu 200.04 server VM to patch the iso. It's possible this script would work in WSL but I haven't tested that. The script just modifies a few lines in some of the setup python scripts. You may be able to do this manually but it requires unpacking and repacking the initrd file on the ISO in a very specific way.

This is an alpha grade script, so use at your own risk. I created a Ubuntu Server 20.04 temporary VM and copied the iso into the VM.

The script has some pre-requesites to install.

    sudo apt install genisoimage

Then copy your downloaded ce-2020.09.16.iso file to the iso directory and run the script.

    git clone <gitlink>
    mkdir ./ahv-on-hyperv/iso
    cp ~/Downloads/ce-2020.09.16.iso ./ahv-on-hyperv/iso/
    cd ahv-on-hyperv/
    chhmod +x patch.sh
    ./patch.sh

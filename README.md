# ahv-on-hyperv

Script to patch the public ce-2020.09.16.iso to run in a Hyper-V guest VM

Patch the iso using the patch.sh script. I used a Ubuntu 20.04 machine to patch the iso. The script has some pre-requesites to install.

    sudo apt install <STUFF HERE>

Then run the script. It requires sudo to mount the original iso.

    git clone <gitlink>
    cd ahv-on-hyperv
    chhmod +x patch.sh
    ./patch.sh

#!/bin/bash
#
# Flash a BIOS to GPUs in an ethOS rig
#
backup='true'
display_help() {
echo    Usage: gpuflash [options]
echo        options:
echo         -b, skip backing up the existing BIOS file. Not recommended.
echo         -h, display this help page


}

while getopts ':bh' flag; do
    case "${flag}" in
        b) backup='false' ;;
        h) display_help
           exit ;;
        *) echo "Unexpected flag. Try -h for help"
           exit ;;
    esac
done


sudo atiflash -i

read -p 'Select GPU: ' targetgpu

if [["$backup" = 'true']]
then
    read -e -p 'Backup Name: ' backupname

    cd ~

    sudo atiflash -s "$targetgpu" "$backupname"

    echo Backup is completed...
fi

cd $globalbiosmountpoint

ls $globalbiosmountpoint

read -e -p 'Select BIOS: ' targetbios

sudo atiflash -f -p "$targetgpu" ~$globalbiosmountpoint/"$targetbios"

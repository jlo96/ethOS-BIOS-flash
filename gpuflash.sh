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

if [[ -z "$globalbiosmountpoint" ]]
then
    read -e -p 'Set the BIOS directory: ' $globalbiosmountpoint
    
    if [[ ! -d "$globalbiosmountpoint" ]]
    then
        mkdir -p "$globalbiosmountpoint"
        echo You need to mount a drive or add a BIOS before you continue
        export $globalbiosmountpoint
        exit
    #elif to check if the newly set $globalbiosmountpoint is empty. This is a bit complicated, so it's on the backburner.
    fi
fi

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

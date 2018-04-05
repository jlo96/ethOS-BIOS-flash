#!/bin/bash
#
# Flash a BIOS to GPUs in an ethOS rig
#
backup='true'
display_help() {
echo    Usage: gpuflash [options]
echo        options:
echo         -b, skip backing up the existing BIOS file. Not recommended.
echo         "-h, display this help page"
echo ""
echo "If you're prompted for a directory and you mounted a drive, check that it was mounted globally. see biosmount -h"
echo "If gpuflash isn't finding your directory, or refuses to make it, be sure to fully type out the path, starting with [/]. ~ is not expanded by default."


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
    read -e -p 'Set the BIOS directory: ' globalbiosmountpoint
    
    if [[ ! -d "$globalbiosmountpoint" ]]
    then
        echo "The directory doesn't exist, attempting to make it"
        sudo mkdir -p "$globalbiosmountpoint"
        if [[ $? -ne 0 ]]
            then
            echo "The directory wasn't made for some reason. Did you not start it with / or did you include ~?"
            exit
        else
            echo "Success"
        fi
        echo You need to mount a drive or add a BIOS before you continue
        export globalbiosmountpoint
        exit
    else
        echo OK, $globalbiosmountpoint was set as the BIOS directory
        export globalbiosmountpoint
    #elif to check if the newly set globalbiosmountpoint is empty. This is a bit complicated, so it's on the backburner.
    fi
else
    echo The BIOS directory is "$globalbiosmountpoint"
fi

sudo atiflash -i

read -p 'Select GPU: ' targetgpu

if [[ "$backup" = 'true' ]]
then
    read -e -p 'Backup Name: ' backupname

    cd $HOME

    sudo atiflash -s "$targetgpu" "$backupname"

    echo Backup is completed...
else
    echo Skipping backup!
fi

cd $globalbiosmountpoint

ls $globalbiosmountpoint

read -e -p 'Select BIOS: ' targetbios

sudo atiflash -f -p "$targetgpu" $globalbiosmountpoint/"$targetbios"

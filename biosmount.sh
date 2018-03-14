#!/bin/bash
#
# Quickly mount the external drive you want to pull your bios from

display_help() {
echo Usage: biosmount [options]
echo  options:
echo   "-m <path>, manually select a mount point. Otherwise, defaults to "$HOME"/mnt/drive2"
echo   "-h, display this help page"

echo "The first time you run biosmount, or if you set a new mount point, you must run it in your parent shell, or gpuflash won't work! Do this by running as . ./biosmount.sh"

}

while getopts "hm:" flag; do
    case "${flag}" in
        m) globalbiosmountpoint=${OPTARG}
           custom='true' ;;
        h) display_help 
           exit ;;
        *) echo "Unexpected flag. Try -h for help" 
           exit ;;
    esac
done

if [[ -z "$globalbiosmountpoint" ]]
then
    globalbiosmountpoint="$HOME"/mnt/drive2
    echo "Setting mount point as ("$globalbiosmountpoint")"
    echo "Unless this is your first run, the mount point might not be globally set"
    echo "Please make sure to ran this script in your parent shell. See -h"
    echo ""
elif [[ -n "$globalbiosmountpoint" && "$custom" = 'true' ]]
then
    echo "Setting mount point as "$globalbiosmountpoint""
    echo "Make sure you ran this script in your parent shell. See -h"
else
    echo "The mount point is "$globalbiosmountpoint""
fi

export globalbiosmountpoint

echo Select the drive to mount:

sudo blkid -c /dev/null

read -e -p 'Drive: ' biosdrive #drive name, e.g. sdb1

drivetype=$(blkid -o value -t TYPE /dev/"$biosdrive")

if [ ! -d "$globalbiosmountpoint" ]
then
    echo Creating mount point...
    sudo mkdir -p "$globalbiosmountpoint"
else
    echo Mount point "$globalbiosmountpoint" exists...
fi

echo OK, mounting "$biosdrive"

sudo mount -t "$drivetype" /dev/"$biosdrive" "$globalbiosmountpoint"

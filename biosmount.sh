#!/bin/bash
#
# Quickly mount the external drive you want to pull your bios from

globalbiosmountpoint=~/mnt/drive2

display_help() {
echo Usage: biosmount [options]
echo  options:
echo   -m, manually select a mount point. Otherwise, defaults to ~/mnt/drive2
echo   -h, display this help page 


}

while getopts "hm:" flag; do
    case "${flag}" in
        m) globalbiosmountpoint=${OPTARG} ;;
        h) display_help 
           exit ;;
        *) echo "Unexpected flag. Try -h for help" 
           exit ;;
    esac
done

export globalbiosmountpoint

echo Select the drive to mount:

sudo blkid -c /dev/null

read -e -p 'Drive: ' biosdrive #drive name, e.g. sdb1

drivetype=$(blkid -o value -s TYPE /dev/"$biosdrive")

if [ ! -d "$globalbiosmountpoint" ]
then
    echo Creating mount point...
    sudo mkdir -p "$globalbiosmountpoint"
else
    echo Mount point "$globalbiosmountpoint" exists...
fi

echo OK, mounting "$biosdrive"

sudo mount -t "$drivetype" /dev/"$biosdrive" "$globalbiosmountpoint"

#!/bin/sh
lsblk

read -r -p "choose your drive ex: (/dev/sda) without the ()s" drive

UUID=$(sudo blkid | grep "$drive" | grep -oP '(?<= UUID=").*?(?=")')

if [ $? -eq 0 ]; then
	echo "the UUID of the chosen drive is: $UUID"
else
	echo "the drive you selected does not exist."
	exit
fi

sudo umount $drive && echo "unmounted the drive (if mounted)."

cp /etc/fstab ~/fstab.old && echo "backed up /etc/fstab at ~/fstab.old."

read -r -p "choose your mount point (provide complete dir) ex: (/dev/storage/) without the ()s" mountpoint
sudo mkdir $mountpoint

sudo sh -c "echo \"#$drive\" >> /etc/fstab"
sudo sh -c "echo \"UUID=$UUID $mountpoint ext4 defaults,nofail 0 2\" >> /etc/fstab"
echo "added the drive in fstab."

sudo systemctl daemon-reload && echo "reloaded."

sudo mount -a && echo "mounted."

#!/bin/sh
sudo apt install xfsprogs -y
sudo fdisk /dev/vdb <<EOF
n
p
1


w
EOF
echo "FORMAT PARTITION"
sudo mkfs.xfs /dev/vdb1
echo "ADD TO FSTAB"
sudo mkdir /var/lib/docker/
sudo echo "/dev/vdb1     /var/lib/docker/               xfs  defaults   0       1 ">>/etc/fstab

echo MOUNT
sudo mount -a




#!/bin/bash
echo CREATE PARTITION
sudo fdisk /dev/vdb <<EOF
n
p
1


w
EOF
echo FORMAT PARTITION
sudo apt install xfsprogs -y
sudo mkfs.xfs /dev/vdb1
echo ADD TO FSTAB
sudo echo "/dev/vdb1     /var/lib/docker/               xfs  defaults   0       1 ">>/etc/fstab
sudo mkdir /var/lib/docker/

echo MOUNT
sudo mount -a


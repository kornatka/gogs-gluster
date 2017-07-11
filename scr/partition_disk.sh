#!/bin/sh
hdd="/dev/vdb"
sudo apt-get install xfsprogs -y

for i in $hdd;do

echo "n
p
1


w
"|sudo fdisk $i
sudo mkdir /var/lib/docker/
sudo mkfs.xfs /dev/vdb1
sudo echo "/dev/vdb1     /var/lib/docker/               xfs  defaults   0       1 ">>/etc/fstab
done


sudo mount /dev/vdb1 /var/lib/docker
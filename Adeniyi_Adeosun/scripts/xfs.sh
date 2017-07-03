sudo apt-get -y update

sudo apt-get install -y xfsprogs
sudo mkfs.xfs /dev/vdb

sudo mkdir /brick

echo -e '/dev/vdb\t/brick\tauto' |sudo tee -a /etc/fstab
sudo mount -a

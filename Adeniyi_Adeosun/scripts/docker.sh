sudo apt-get update

sudo apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common

sudo add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) \
	stable"

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add

sudo apt-get update
sudo apt-get -y --force-yes install docker-ce
sudo apt-get -y upgrade

sudo usermod -aG docker vagrant

wget -q https://github.com/docker/compose/releases/download/1.13.0/docker-compose-`uname -s`-`uname -m`
sudo mv docker-compose-`uname -s`-`uname -m` /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

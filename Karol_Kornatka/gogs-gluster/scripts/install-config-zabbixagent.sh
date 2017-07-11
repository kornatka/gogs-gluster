sudo apt install zabbix-agent -y
sudo service zabbix-agent stop
sudo cp /vagrant/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
sudo service zabbix-agent start

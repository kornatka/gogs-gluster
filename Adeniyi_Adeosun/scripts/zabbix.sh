sudo apt-get install -y zabbix-agent

sudo sed -i /Server/s/127.0.0.1/192.168.7.15/ \
	/etc/zabbix/zabbix_agentd.conf

sudo systemctl restart zabbix-agent

# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

Vagrant.configure(2) do |config|

	config.vm.provider :libvirt do |libvirt|
		libvirt.host = '192.168.122.1'
		libvirt.username = "4kvm"
		libvirt.connect_via_ssh = true
		libvirt.driver = "kvm"
		libvirt.storage_pool_name = "VMS"
	end

	config.vm.box = "https://s3.otlabs.fr/index.php/s/tPeoTjFJ7I870GQ/download"

	config.vm.provision "shell", run: "always", inline: " echo nameserver 8.8.8.8 > /etc/resolv.conf"
	config.vm.provision "shell", path: "scripts/xfs.sh"
	config.vm.provision "shell", path: "scripts/docker.sh"
	config.vm.provision "shell", path: "scripts/zabbix.sh"
	config.vm.provision "shell", path: "scripts/gluster-deploy.sh"
	
	(1..3).each do |n|
		config.vm.define "niyiGitea#{n}" do |niyiGitea|
			niyiGitea.vm.hostname = "node#{n}"
			niyiGitea.vm.network :public_network, ip: "192.168.7.25#{n}", netmask: "22", :dev => "enp4s0", :mode => 'bridge'
			niyiGitea.vm.network :public_network, ip: "10.10.20.1#{n}", netmask: "22", :dev => "enp7s0.4", :mode => 'bridge'
			
			if n == 2
				niyiGitea.vm.network :public_network, ip: "192.168.2.25#{n}", netmask: "22", :dev => "enp7s0.4", :mode => 'bridge'
			end
			
			niyiGitea.vm.synced_folder ".", "/vagrant", disabled: false
			
			if n < 3
				niyiGitea.vm.provision "deploy-gitea", type: "shell", path: "scripts/gitea-deploy.sh", run: "never"
				niyiGitea.vm.provision "rescale", type: "shell", path: "scripts/rescale.sh", run: "never"
			end
			
			niyiGitea.vm.provider :libvirt do |domain|
				domain.storage :file, :size => '20G'
				domain.memory = 1024
				domain.cpus = 1
			end
		end
	end

end

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
libvirt.storage :file, :size => '40G', :type => 'raw'
end

config.vm.box = "https://s3.otlabs.fr/index.php/s/tPeoTjFJ7I870GQ/download"
config.vm.provision "shell",
 run: "always",
 inline: " echo nameserver 8.8.8.8 > /etc/resolv.conf"
	config.vm.define :karol1 do |karol1|
	  karol1.vm.hostname = "karol1"
	  karol1.vm.network :public_network, ip: '192.168.7.111', netmask: "22", :dev => "enp4s0", :mode => 'bridge'
	  karol1.vm.synced_folder "./scripts", "/vagrant", disabled: false
	  karol1.vm.provision "shell" , inline: "/vagrant/update.sh"
	  karol1.vm.provision "shell" , inline: "/vagrant/provision-hdd.sh"
	  karol1.vm.provision "shell" , inline: "/vagrant/install-docker.sh"
	  karol1.vm.provision "shell" , inline: "/vagrant/deploy-gluster.sh"
	  karol1.vm.provision "shell" , inline: "/vagrant/deploy-gogs.sh"
	  karol1.vm.provision "shell" , inline: "/vagrant/install-config-zabbixagent.sh"
	  karol1.vm.provider :libvirt do |domain|
	    domain.memory = 1024
	    domain.cpus = 1
	  end
	end
	 config.vm.define :karol2 do |karol2| 
          karol2.vm.hostname = "karol2"
          karol2.vm.network :public_network, ip: '192.168.7.112', netmask: "22", :dev => "enp4s0", :mode => 'bridge'
          karol2.vm.synced_folder "./scripts", "/vagrant", disabled: false
          karol2.vm.provision "shell" , inline: "/vagrant/update.sh"
	  karol2.vm.provision "shell" , inline: "/vagrant/provision-hdd.sh"
          karol2.vm.provision "shell" , inline: "/vagrant/install-docker.sh"
	  karol2.vm.provision "shell" , inline: "/vagrant/deploy-gluster.sh"
          karol2.vm.provision "shell" , inline: "/vagrant/deploy-gogs.sh"
          karol2.vm.provision "shell" , inline: "/vagrant/install-config-zabbixagent.sh"
          karol2.vm.provider :libvirt do |domain|
            domain.memory = 1024
            domain.cpus = 1
          end
        end
         config.vm.define :karol3 do |karol3|
          karol3.vm.hostname = "karol3"
          karol3.vm.network :public_network, ip: '192.168.7.113', netmask: "22", :dev => "enp4s0", :mode => 'bridge'
          karol3.vm.synced_folder "./scripts", "/vagrant", disabled: false
          karol3.vm.provision "shell" , inline: "/vagrant/update.sh"
	  karol3.vm.provision "shell" , inline: "/vagrant/provision-hdd.sh"
          karol3.vm.provision "shell" , inline: "/vagrant/install-docker.sh"
          karol3.vm.provision "shell" , inline: "/vagrant/deploy-gluster.sh"
          karol3.vm.provision "shell" , inline: "/vagrant/install-config-zabbixagent.sh"
          karol3.vm.provider :libvirt do |domain|
            domain.memory = 1024
            domain.cpus = 1
          end
        end


end

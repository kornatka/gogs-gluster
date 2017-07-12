
# -*- mode: ruby -*-
# vi: set ft=ruby :
NEW_DISK = "./dockerdisk.vdi"
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
config.vm.provision "shell",
 run: "always",
 inline:" echo nameserver 8.8.8.8 > /etc/resolv.conf"

	config.vm.define :feyi do |feyi1|
	  feyi1.vm.hostname = "docker1"
	  feyi1.vm.network :public_network, ip: '192.168.7.230', netmask: "22", :dev => "enp4s0", :mode => 'bridge'
	  feyi1.vm.network :public_network, ip: '10.10.40.1', netmask: "22", :dev => "enp4s0", :mode => 'bridge'
	  #feyi1.vm.network :forwarded_port, guest: 80, host: 4567
	  feyi1.vm.synced_folder "scr", "/vagrant", disabled: false
	  feyi1.vm.provision "shell" , inline: "/vagrant/updatedockers.sh"
      feyi1.vm.provision "shell" , inline: "/vagrant/install-zabbix.sh"
	  feyi1.vm.provision "shell" , inline: "/vagrant/partition_disk.sh"
	  feyi1.vm.provision "shell" , inline: "/vagrant/docker.sh"
      feyi1.vm.provision "shell" , inline: "/vagrant/run_compose_gluster1.sh"
	  feyi1.vm.provision "shell" , inline: "/vagrant/run_compose_gogs.sh"
	  feyi1.vm.provider :libvirt do |domain|
	    domain.storage :file, :size =>'50G', :type => 'raw'
	    domain.memory = 1024
	    domain.cpus = 1
        end		
       end 	
         config.vm.define :feyi2 do |feyi2|
          feyi2.vm.hostname = "docker2"
          feyi2.vm.network :public_network, ip: '192.168.7.239', netmask: "22", :dev => "enp4s0", :mode => 'bridge'
          feyi2.vm.network :public_network, ip: '10.10.40.2', netmask: "22", :dev => "enp4s0", :mode => 'bridge'
		  #feyi2.vm.network :forwarded_port, guest: 80, host: 4568
		  feyi2.vm.network :public_network, ip: '192.168.2.239', netmask: "22", :dev => "enp7s0.4", :mode => 'bridge'
          feyi2.vm.synced_folder "scr", "/vagrant", disabled: false
		  feyi2.vm.provision "shell" , inline: "/vagrant/updatedockers.sh"
	      feyi2.vm.provision "shell" , inline: "/vagrant/install-zabbix.sh"
          feyi2.vm.provision "shell" , inline: "/vagrant/partition_disk.sh"
		  feyi2.vm.provision "shell" , inline: "/vagrant/docker.sh"
	      feyi2.vm.provision "shell" , inline: "/vagrant/run_compose_gluster1.sh"
		  feyi2.vm.provision "shell" , inline: "/vagrant/run_compose_gogs.sh"
          feyi2.vm.provider :libvirt do |domain|
	      domain.storage :file, :size =>'50G', :type => 'raw'	
            domain.memory = 1024
            domain.cpus = 1
          end
	 end
	 config.vm.define :feyi3 do |feyi3|
       feyi3.vm.hostname = "docker-gluster"
	   feyi3.vm.network :public_network, ip: '192.168.7.250', netmask: "22", :dev => "enp4s0", :mode => 'bridge'
       feyi3.vm.network :public_network, ip: '10.10.40.3', netmask: "22", :dev => "enp4s0", :mode => 'bridge'
	   #feyi3.vm.network :forwarded_port, guest: 80, host: 4569   
	   feyi3.vm.synced_folder "scr", "/vagrant", disabled: false
	   feyi3.vm.provision "shell" , inline: "/vagrant/updatedockers.sh" 
       feyi3.vm.provision "shell" , inline: "/vagrant/install-zabbix.sh" 
	   feyi3.vm.provision "shell" , inline: "/vagrant/partition_disk.sh"
	   feyi3.vm.provision "shell" , inline: "/vagrant/docker.sh"
	   feyi3.vm.provision "shell" , inline: "/vagrant/run_compose_gluster1.sh"
       feyi3.vm.provider :libvirt do |domain|
            domain.storage :file, :size =>'50G', :type => 'raw'
            domain.memory = 1024
            domain.cpus = 1
       end
       end

end

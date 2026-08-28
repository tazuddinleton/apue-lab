Vagrant.configure("2") do |config|
  config.vm.box = "generic/netbsd9"
  config.vm.box_check_update = false
  config.vm.hostname = "apue-netbsd9"

  config.vm.synced_folder ".", "/vagrant", disabled: false
  config.vm.provision "shell", path: "provision.sh"

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 2
    libvirt.memory = 2048
  end

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.cpus = 2
    virtualbox.memory = 2048
  end
end

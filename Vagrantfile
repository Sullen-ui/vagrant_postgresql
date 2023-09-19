Vagrant.configure("2") do |config|
  vms = [
    { name: "app01", box: "Rocky9.2", hostname: "app01", ip: "192.168.33.11" },
    { name: "gitlab", box: "Rocky9.2", hostname: "gitlab", ip: "192.168.33.12" },
    { name: "vpn01", box: "Rocky9.2", hostname: "vpn01", ip: "192.168.33.10" },
    { name: "db01", box: "Rocky9.2", hostname: "db01", ip: "192.168.33.13", provision: "postgres_install.sh" }
  ]

  vms.each do |vm_data|
    config.vm.define vm_data[:name] do |vm|
      vm.vm.box = vm_data[:box]
      vm.vm.hostname = vm_data[:hostname]
      vm.vm.network "private_network", type: "static", ip: vm_data[:ip]

      vm.vm.provider "virtualbox" do |vb|
        vb.name = vm_data[:name]
        vb.memory = 1024
        vb.cpus = 2
      end

      if vm_data[:provision]
        vm.vm.provision "shell", path: vm_data[:provision]
      end
    end
  end
end
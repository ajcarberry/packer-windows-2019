# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "file://builds/windows-2019.box"
  #config.vm.box = "file://builds/windows-2019-core.box"
  config.vm.define "packerWindows" do |virtualbox|
  end

  config.vm.network "private_network", ip: "172.16.1.5"

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.name = "packerWindows"
    vb.memory = 2048
    vb.cpus = 1
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  # Enable provisioning with Ansible
  config.vm.provision "ansible_local" do |ansible|
    ansible.become = true
    ansible.galaxy_roles_path = "/etc/ansible/roles"
    ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
    ansible.galaxy_role_file = "requirements.yml"
    ansible.playbook = "ansible/main.yml"
  end
end

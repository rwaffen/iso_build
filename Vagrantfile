# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "puppetlabs/centos-7.2-64-puppet"
  config.vm.box_check_update = false
  config.vm.provision "shell", inline: "/bin/bash -x /vagrant/create.sh"
end

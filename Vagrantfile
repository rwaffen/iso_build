# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "boxomatic/centos-stream-9"
  config.vm.box_check_update = false
  config.vm.provision "shell", inline: "/bin/bash -x /vagrant/create.sh"
end

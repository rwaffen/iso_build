# Tell anaconda we're doing a fresh install and not an upgrade
# Set the root password! Remember to change this once the install has completed!
# python -c 'import crypt; print(crypt.crypt("My Password", "$6$My salt"))'

# installation options
install
text
cdrom
logging  --level=debug
repo --name="CentOS7" --baseurl=file:///mnt/source --cost=100

# config system
keyboard de
lang en_US.UTF-8
timezone   --utc Europe/Berlin
rootpw     --iscrypted $6Xe976bw.6V2
network    --bootproto=dhcp
# network  --device=eth0 --bootproto=static --ip=10.1.2.3 --netmask=255.255.255.0 --gateway=10.1.2.1 --nameserver=8.8.8.8 --onboot=yes
firstboot  --disabled
# firewall --disabled
authconfig --enableshadow --passalgo=sha512
# selinux  --permissive
# services --disabled NetworkManager --enabled sshd
services   --enabled sshd

# partitioning
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
zerombr
clearpart  --all --initlabel --drives=sda
autopart   --type=lvm --nohome  

# install packages
%packages
@core
puppet-agent
open-vm-tools
net-tools
perl
%end

reboot --eject

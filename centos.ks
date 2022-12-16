# installation options
text
url    --url="https://ftp.plusline.net/centos-stream/9-stream/BaseOS/x86_64/os"
repo   --name="AppStream" --baseurl="https://ftp.plusline.net/centos-stream/9-stream/AppStream/x86_64/os"
reboot --eject

# config system
keyboard de
lang en_US.UTF-8
timezone --utc Europe/Berlin
rootpw   --plaintext change_me
network  --bootproto=dhcp

# partitioning
zerombr
clearpart --all --initlabel
autopart  --nohome --noswap

# install packages
%packages
@core
%end

# enable Kdump
%addon com_redhat_kdump --enable --reserve-mb='auto'
%end

%post
# install puppet
dnf install -y https://yum.puppetlabs.com/puppet7-release-el-9.noarch.rpm
dnf install -y puppet-agent puppet-bolt
%end

#!/bin/bash
CENTOS_SOURCE_ISO_URL="https://ftp.tu-chemnitz.de/pub/linux/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-2009.iso"
CENTOS_CUSTOM_PATH=/data/build
ISO_MOUNTPOINT=/mnt
ISO=/vagrant/CentOS-7-x86_64-Minimal-2009-Kickstart.iso

function cleanup()
{
  sudo umount $ISO_MOUNTPOINT
}

cd /vagrant
sudo yum install -q -y wget
sudo yum install -q -y epel-release

[[ ! -f $(basename $CENTOS_SOURCE_ISO_URL) ]] && wget -nv $CENTOS_SOURCE_ISO_URL

sudo yum -q -y install https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
sudo yum -q -y install rsync yum-utils createrepo genisoimage isomd5sum
sudo mount -o loop,ro $(basename $CENTOS_SOURCE_ISO_URL) /mnt

sudo mkdir -p $CENTOS_CUSTOM_PATH
cd $CENTOS_CUSTOM_PATH
sudo rsync --exclude=TRANS.TBL -av $ISO_MOUNTPOINT/ .

cd $CENTOS_CUSTOM_PATH/Packages
sudo find /var/cache/yum/ -type f -name '*.rpm'
sudo yumdownloader --resolve \
  puppet-agent \
  net-tools \
  open-vm-tools \
  perl \
  perl-Carp \
  perl-Exporter \
  perl-File-Path \
  perl-File-Temp \
  perl-Filter \
  perl-Getopt-Long \
  perl-PathTools \
  perl-Pod-Simple \
  perl-Scalar-List-Utils \
  perl-Socket \
  perl-Storable \
  perl-Time-HiRes \
  perl-Time-Local \
  perl-constant \
  perl-libs \
  perl-macros \
  perl-threads \
  perl-threads-shared \
  perl-Encode \
  perl-Text-ParseWords \
  perl-Pod-Usage \
  perl-Pod-Escapes \
  perl-Pod-Perldoc \
  perl-podlators \
  perl-parent \
  perl-HTTP-Tiny

cd $CENTOS_CUSTOM_PATH/repodata
sudo mv ./*minimal-x86_64-comps.xml comps.xml && {
ls | grep -v comps.xml | xargs sudo rm -rf
}

cd $CENTOS_CUSTOM_PATH
sudo createrepo -g repodata/comps.xml $CENTOS_CUSTOM_PATH || { cleanup ; exit 1 ; }

sudo cp /vagrant/cento.ks $CENTOS_CUSTOM_PATH/ks.cfg

sudo sed -i -e '
s,timeout 600,timeout 1,
s,append initrd=initrd.img.*$,append initrd=initrd.img inst.stage2=hd:LABEL=CentOS7 ks=cdrom:/ks.cfg net.ifnames=0 biosdevname=0,' $CENTOS_CUSTOM_PATH/isolinux/isolinux.cfg

sudo mkisofs -r -R -J -T -v -no-emul-boot \
-boot-load-size 4 \
-boot-info-table \
-V "CentOS7" \
-publisher "rwaffen" \
-A "CentOS7" \
-b isolinux/isolinux.bin \
-c isolinux/boot.cat \
-x "lost+found" \
--joliet-long \
-o $ISO .

sudo implantisomd5 $ISO

cleanup

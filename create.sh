#!/bin/bash
CENTOS_SOURCE_ISO_URL="https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-latest-x86_64-boot.iso"
# CENTOS_SOURCE_ISO_URL="https://mirror.checkdomain.de/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-latest-boot.iso"
CENTOS_CUSTOM_PATH=/data/build
ISO_MOUNTPOINT=/mnt
ISO=/vagrant/CentOS-Stream-9-x86_64-Minimal-Kickstart.iso
# ISO=/vagrant/CentOS-Stream-8-x86_64-Minimal-Kickstart.iso

cd /vagrant
sudo dnf install -q -y wget

[[ ! -f $(basename $CENTOS_SOURCE_ISO_URL) ]] && wget -nv $CENTOS_SOURCE_ISO_URL

sudo dnf -q -y install rsync genisoimage isomd5sum
sudo mount -o loop,ro $(basename $CENTOS_SOURCE_ISO_URL) /mnt

sudo mkdir -p $CENTOS_CUSTOM_PATH
cd $CENTOS_CUSTOM_PATH
sudo rsync --exclude=TRANS.TBL -av $ISO_MOUNTPOINT/ .

sudo cp /vagrant/centos.ks $CENTOS_CUSTOM_PATH/ks.cfg

sudo sed -i 's,timeout 600,timeout 1,' $CENTOS_CUSTOM_PATH/isolinux/isolinux.cfg
sudo sed -i 's,append initrd=initrd.img.*$,append initrd=initrd.img inst.repo=cdrom inst.ks=cdrom:/ks.cfg inst.nompath rhgb quiet,' $CENTOS_CUSTOM_PATH/isolinux/isolinux.cfg

sudo mkisofs \
  -b isolinux/isolinux.bin \
  -c isolinux/boot.cat \
  --no-emul-boot \
  --boot-load-size 4 \
  --boot-info-table \
  -o $ISO \
  -J -R -V "CentOS" .

sudo umount /mnt

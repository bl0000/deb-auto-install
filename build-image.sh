#!/bin/bash

sudo rm -r /srv/tftp/*

sudo cp netboot.tar.gz /srv/tftp

sudo cp preseed.cfg /srv/tftp

cd /srv/tftp

sudo tar -xvf netboot.tar.gz

sudo rm netboot.tar.gz

sudo gunzip debian-installer/amd64/initrd.gz

echo preseed.cfg | sudo cpio -H newc -o -A -F debian-installer/amd64/initrd

sudo gzip debian-installer/amd64/initrd

sudo rm preseed.cfg

echo "default install" | sudo tee -a debian-installer/amd64/boot-screens/syslinux.cfg

sudo sed -i 's|append vga=788 initrd=debian-installer/amd64/initrd.gz --- quiet|append vga=788 initrd=debian-installer/amd64/initrd.gz auto=true priority=critical --- quiet|' debian-installer/amd64/boot-screens/txt.cfg

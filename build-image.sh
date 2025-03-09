#!/bin/bash

# Check if .env file exists and load values
if [[ ! -f .env ]]; then
    echo ".env file not found!"
    exit 1
fi

while IFS='=' read -r key value; do
    case "$key" in
        password) password="$value" ;;
        preseed_file) preseed_file="$value" ;;
        hostname) hostname="$value" ;;
        domain) domain="$value" ;;
    esac
done < .env

# Remove existing PXE configuration
sudo rm -r /srv/tftp/*

# Copy files over, extract then remove archive
sudo cp netboot.tar.gz /srv/tftp
sudo cp "$preseed_file" /srv/tftp
cd /srv/tftp
sudo tar -xvf netboot.tar.gz
sudo rm netboot.tar.gz

# Change default values of preseed file
sudo sed i 's/insecure_pw/$password/g' "preseed.cfg"
sudo sed i 's/unassigned-hostname/$hostname/g' "preseed.cfg"
sudo sed i 's/unassigned-domain/$domain/g' "preseed.cfg"

# Unzip initrd.gz, append preseed configuration, remove file
sudo gunzip debian-installer/amd64/initrd.gz
echo preseed.cfg | sudo cpio -H newc -o -A -F debian-installer/amd64/initrd
sudo gzip debian-installer/amd64/initrd
sudo rm preseed.cfg

# Automatically start installing Debian
echo "default install" | sudo tee -a debian-installer/amd64/boot-screens/syslinux.cfg

sudo sed -i 's|append vga=788 initrd=debian-installer/amd64/initrd.gz --- quiet|append vga=788 initrd=debian-installer/amd64/initrd.gz auto=true priority=critical --- quiet|' debian-installer/amd64/boot-screens/txt.cfg

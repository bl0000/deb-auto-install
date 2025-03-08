#!/bin/bash

sudo apt update

sudo apt install tftpd-hpa pxelinux

sudo systemctl start tftpd-hpa

curl https://deb.debian.org/debian/dists/bookworm/main/installer-amd64/current/images/netboot/netboot.tar.gz -o netboot.tar.gz

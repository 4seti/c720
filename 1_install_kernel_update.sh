#!/bin/bash
# this will update the kernel to 3.16 (Crunchbang on Acer C720)

kernel_image=linux-image-3.16.0-0.bpo.4-amd64

echo "Updating /etc/apt/sources.list..."
cat<<EOT > /etc/apt/sources.list

## Crunchbang
deb http://packages.crunchbang.org/waldorf waldorf main
deb-src http://packages.crunchbang.org/waldorf waldorf main

## Debian
deb http://http.debian.net/debian wheezy main contrib non-free
deb-src http://http.debian.net/debian wheezy main contrib non-free

## Debian Security
deb http://security.debian.org/ wheezy/updates main
deb-src http://security.debian.org/ wheezy/updates main

## Debian Backports
deb http://http.debian.net/debian wheezy-backports main

## Debian Multimedia
deb http://www.deb-multimedia.org wheezy main non-free
EOT

sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1F41B907

echo "Updating /etc/apt/preferences..."
cat<<EOT > /etc/apt/preferences
Package: *
Pin: release a=waldorf
Pin-Priority: 1001

Package: *
Pin: release a=wheezy
Pin-Priority: 500

Package: *
Pin: release a=wheezy-backports
Pin-Priority: 100

EOT

echo "Updating index of packages..."
apt-get update

echo "Installing kernel image..."
apt-get install -y --force-yes -t wheezy-backports $kernel_image


echo "Kernel installation complete."
echo "Please reboot into your new kernel."

exit


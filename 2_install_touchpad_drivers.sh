#!/bin/bash

# Patches kernel 3.16 for acer c720 touchpad
# https://lkml.org/lkml/2014/6/17/609

# Acer c720 is dual core
nprocs=2

mykern=$(uname -a | awk '{print $3}')
mykernver=linux-3.16

# Create a temp directory for our work
tempbuild=`mktemp -d`
cd $tempbuild

# Install necessary deps to build a kernel
sudo apt-get build-dep -y --no-install-recommends linux-image-$mykern

# Grab kernel source and extract
wget -O - 'https://www.kernel.org/pub/linux/kernel/v3.x/'$mykernver'.tar.xz' | tar xfJ -
cd $mykernver

# Get the touchpad patch
wget -O - https://patchwork.kernel.org/patch/4370091/raw/ | patch -p1

# Need this
cp /usr/src/linux-headers-$mykern/Module.symvers .

# Prep tree
cp /boot/config-$mykern ./.config
make -j $nprocs oldconfig
make -j $nprocs prepare
make -j $nprocs modules_prepare

# Build only the needed directories
make -j $nprocs SUBDIRS=drivers/platform/chrome modules

# switch to using our new chromeos_laptop.ko module, preserve old as .orig
sudo mv /lib/modules/$mykern/kernel/drivers/platform/chrome/chromeos_laptop.ko{,.orig}
sudo cp drivers/platform/chrome/chromeos_laptop.ko /lib/modules/$mykern/kernel/drivers/platform/chrome/

sudo depmod -a $mykern

echo "Finished building Acer c720 touchpad module in $tempbuild. Reboot to use it."

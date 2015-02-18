#!/bin/bash
# this will install infinality fonts for debian


# clone the git repo
cd /home/jcd/
git clone https://github.com/chenxiaolong/Debian-Packages.git
cd Debian-Packages/

# Install the build dependencies. Run the following
sudo apt-get -y --force-yes install devscripts docbook
sudo apt-get -y --force-yes install docbook-to-man

# dpkg-checkbuilddeps in freetype-infinality/
# & fontconfig-infinality/ for missing deps

# Build the packages:
cd /home/jcd/Debian-Packages/freetype-infinality/
sudo ./build.sh
cd /home/jcd/Debian-Packages/fontconfig-infinality/
sudo ./build.sh

# Install the deb files:

cd ..
sudo dpkg -i freetype-infinality/*.deb fontconfig-infinality/*.deb

#echo "Installing Anonymous Pro font..."
#cd ~
#wget http://www.marksimonson.com/assets/content/fonts/AnonymousPro-1.002.zip
#unzip AnonymousPro-1.002.zip
#mv AnonymousPro-1.002.001/*.ttf ~/.fonts
#rm AnonymousPro-1.002.zip
#rm -r AnonymousPro-1.002.001

sudo /etc/fonts/infinality/infctl.sh setstyle
echo "Reboot to complete font installation"

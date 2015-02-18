#!/bin/bash

## install stuff
sudo apt-get -y --force-yes rkhunter chkrootkit ufw keepass2

## disable and blacklist webcam
sudo modprobe -r uvcvideo
sudo touch /etc/modprobe.d/blacklist.conf
sudo printf '%s' 'blacklist uvcvideo' >> /etc/modprobe.d/blacklist.conf

## microphone mute (included in openbox autostart file)
/usr/bin/amixer set Capture nocap

## install firewall rules
sudo cp storage/activate_firewall.sh /usr/share/sbin/
sudo chmod +x /usr/share/sbin/activate_firewall.sh
sudo activate_firewall.sh start
sudo apt-get install iptables-persistent

exit 0

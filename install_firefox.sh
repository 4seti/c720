#!/bin/bash

sudo apt-get remove iceweasel
sudo echo -e "\ndeb http://downloads.sourceforge.net/project/ubuntuzilla/apt all main" |
sudo tee -a /etc/apt/sources.list > /dev/null
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com C1289A29
sudo apt-get update
sudo apt-get install firefox-mozilla-build
sudo apt-get purge flashplugin-nonfree

exit 0

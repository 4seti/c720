#!/bin/bash

# downloads and installs dropbox. also adds it to start on boot

cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
cat << EOT >> ~/.config/openbox/autostart

## dropbox
/home/jcd/.dropbox-dist/dropbox-lnx.x86_64-3.0.4/dropbox

EOT

/home/jcd/.dropbox-dist/dropbox-lnx.x86_64-3.0.4/dropbox &

exit 0

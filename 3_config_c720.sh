#!/bin/bash

user=$(whoami)

touch rc.local
cat << EOT >> rc.local
echo EHCI > /proc/acpi/wakeup
echo HDEF > /proc/acpi/wakeup
echo XHCI > /proc/acpi/wakeup
echo LID0 > /proc/acpi/wakeup
echo TPAD > /proc/acpi/wakeup
echo TSCR > /proc/acpi/wakeup

exit 0
EOT

touch tpm_tis.conf
cat << EOT >> tpm_tis.conf
options tpm_tis force=1
EOT

touch 05_sound
cat << EOT >> 05_sound
#!/bin/bash
case "${1}" in
    hibernate|suspend)
        echo -n "0000:00:1d.0" | tee /sys/bus/pci/drivers/ehci-pci/unbind
        echo -n "0000:00:1b.0" | tee /sys/bus/pci/drivers/snd_hda_intel/unbind
        echo -n "0000:00:03.0" | tee /sys/bus/pci/drivers/snd_hda_intel/unbind
        ;;
    resume|thaw)
        echo -n "0000:00:1d.0" | tee /sys/bus/pci/drivers/ehci-pci/bind
        echo -n "0000:00:1b.0" | tee /sys/bus/pci/drivers/snd_hda_intel/bind
        echo -n "0000:00:03.0" | tee /sys/bus/pci/drivers/snd_hda_intel/bind
        ;;
esac
EOT

# touchpad config
sudo touch 10-evdev.conf
cat << EOT > 10-evdev.conf
#
# Catch-all evdev loader for udev-based systems
# We don't simply match on any device since that also adds accelerometers
# and other devices that we don't really want to use. The list below
# matches everything but joysticks.

Section "InputClass"
        Identifier "evdev pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        Option "AreaRightEdge" "850"
        Option "AreaLeftEdge" "50"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
        Option "FingerHigh" "15"
        Option "FingerLow" "15"
        Option "MaxTapMove" "20"
        Option "HorizTwoFingerScroll" "1"
EndSection

Section "InputClass"
        Identifier "evdev tablet catchall"
        MatchIsTablet "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection
EOT

sudo mv tpm_tis.conf /etc/modprobe.d/tpm_tis.conf
sudo chmod +x /etc/modprobe.d/tpm_tis.conf

sudo mv 05_sound /etc/pm/sleep.d/05_sound
sudo chmod +x /etc/pm/sleep.d/05_sound

sudo mv rc.local /etc/rc.local

sudo rm /usr/share/X11/xorg.conf.d/10-evdev.conf
sudo mv 10-evdev.conf /usr/share/X11/xorg.conf.d/10-evdev.conf

cp storage/adjust_backlight.sh /home/$user/bin/adjust_backlight.sh
chmod +x /home/$user/bin/adjust_backlight.sh
sudo echo "ALL ALL = (ALL) NOPASSWD: /usr/bin/tee /sys/class/backlight/intel_backlight/brightness" >> /etc/sudoers


exit 0

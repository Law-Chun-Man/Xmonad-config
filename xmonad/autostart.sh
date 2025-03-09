#!/bin/bash
xmodmap .Xmodmap
xfce4-clipman &
/usr/bin/sudo tlp start
picom --backend glx --vsync -b
#picom --backend glx --vsync --corner-radius 10 --inactive-opacity 0.8 -b
nm-applet &
xset s 600
/usr/lib/x86_64-linux-gnu/libexec/kdeconnectd &
dunst &
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
pactl get-source-mute @DEFAULT_SOURCE@ | grep -q 'no' && pactl set-source-mute @DEFAULT_SOURCE@ toggle &
#blueman-applet &
#/bin/bash -c "sudo rfkill unblock bluetooth"
#echo schedutil | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
#ibus start &

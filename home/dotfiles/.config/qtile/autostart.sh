#!/usr/bin/env bash

### AUTOSTART PROGRAMS ###
# wl-clipboard-history -t &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=qtile &
# start authentication agent
/usr/lib64/polkit-kde-authentication-agent-1 &
#exec kwalletd6
/usr/lib/pam_kwallet_init --no-startup-id &
sleep 2 &
nm-applet --indicator &
dunst &
# start gammastep indicator for systray
exec gammastep-indicator &
#kanshi &

#! /bin/sh
osname=$(grep '^NAME=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
if [ $osname == "NixOS" ]; then
	$HOME/.config/sway/scripts/autotiling/main_nixos.py
else
	$HOME/.config/sway/scripts/autotiling/main.py
fi

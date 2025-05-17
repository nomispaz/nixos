{config, pkgs, lib, ... }:
{
  imports =
    [ 
    ];

  services.xserver = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}

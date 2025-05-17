{config, pkgs, lib, ... }:
{
  imports =
    [ 
    ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
}

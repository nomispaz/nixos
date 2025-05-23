{config, pkgs, lib, ... }:

{
  imports = [
  ];

  services.desktopManager.cosmic = {
    enable = true;
    xwayland.enable = true;
  };
}

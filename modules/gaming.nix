{config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.steam = {
      enable = true;
  };

  environment.systemPackages = with pkgs; [
    winetricks
    wine
    mangohud
    lutris
  ];

}

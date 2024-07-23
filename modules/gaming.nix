{config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.steam = {
      enable = true;
  };

  environment.systemPackages = with pkgs; [
    gamemode
    winetricks
    wine
    mangohud
  ];

}

{config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.steam = {
      enable = true;
      #package = pkgs.unstable.steam;
  };

  environment.systemPackages = with pkgs; [
    winetricks
    wine
    mangohud
    lutris
  ];

}

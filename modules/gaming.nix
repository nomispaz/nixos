{config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.steam = {
      enable = true;
      package = pkgs.unstable.steam;
  };

  environment.systemPackages = with pkgs.unstable; [
    winetricks
    wine
    mono
    mangohud
    lutris
    heroic-unwrapped
  ];

}

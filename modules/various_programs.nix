{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    calibre
    clipgrab
    discord
    obs-studio
    thunderbird
    libreoffice
  ];

}

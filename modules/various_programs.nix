{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    calibre
    clipgrab
    obs-studio
    thunderbird
    libreoffice
    asunder
    rclone
  ];

  # activate flatpak
  services.flatpak.enable = true;

}

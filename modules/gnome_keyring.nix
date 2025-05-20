{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gnome.enableGnomeKeyring = true;

}

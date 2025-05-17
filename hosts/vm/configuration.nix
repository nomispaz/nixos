# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../filesystems.nix
    ];

  # define hostname
  networking.hostName = "vm";

  # virtualisation
  # virtualbox
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.draganddrop = true;
  virtualisation.virtualbox.guest.clipboard = true;
  services.xserver.videoDrivers = [ "vmware" ];

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      i3status
      rofi
      dunst
    ];
  };
}

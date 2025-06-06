# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../filesystems.nix

      # modules
      ../../modules/users.nix
	    ../../modules/sway.nix
	    ../../modules/basic_programs.nix
	    ../../modules/kernel.nix
	    ../../modules/gnome.nix
	    ../../modules/basic_system.nix
	    ../../modules/bootloader.nix
	    ../../modules/gnome_keyring.nix
      ../../modules/linutil.nix
    ];

  # define hostname
  networking.hostName = "vmnixos";

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

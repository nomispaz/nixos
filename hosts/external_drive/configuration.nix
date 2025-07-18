# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../filesystems.nix

      # modules
      ../../modules/users.nix
	    ../../modules/amd.nix
	    ../../modules/virt-manager.nix
	    ../../modules/various_programs.nix
	    ../../modules/sway.nix
	    ../../modules/basic_programs.nix
	    ../../modules/kernel.nix
	    ../../modules/programming.nix
	    ../../modules/gnome.nix
	    ../../modules/basic_system.nix
	    ../../modules/gnome_keyring.nix
	    ../../modules/linutil.nix
      ../../modules/cosmic.nix
      ../../modules/zen-browser.nix
      ../../modules/niri.nix
      ../../modules/cosmic_niri_integration.nix

    ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      # this option is necessary so that the os can be started on every uefi-enabled computer
      efiInstallAsRemovable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = false;
    };
  };
 
  # define hostname
  networking.hostName = "BootFromExtDrive";

}

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

 hardware.firmware = [
   (pkgs.runCommand "gsl1680-trekstor-primebook-c13" { } ''
     mkdir -p $out/lib/firmware/silead
     cp -r ${./gsl1680-trekstor-primebook-c13.fw} $out/lib/firmware/silead/gsl1680-trekstor-primebook-c13.fw
   '')
 ];

  # linux kernel
  # use stable kernel so that recompiling is not required that often
  boot = {
    #kernelPackages = pkgs.unstable.linuxPackages_latest;
    kernelParams = [
      "mitigations=auto"
      "security=apparmor"
    ];
  };

services.libinput.enable = true;

  # paramters are disabled because the compilations will happen on a different host
  #boot.kernelPatches = [
  #      {
  #        name = "touchscreen support";
  #        patch = null;
  #        extraStructuredConfig = with lib.kernel; {
  #          TOUCHSCREEN_DMI = yes;
  #	    EFI_EMBEDDED_FIRMWARE = yes;
  #	  };
  #	}
  #    ];
 
  # define hostname
  networking.hostName = "trekstor";

}

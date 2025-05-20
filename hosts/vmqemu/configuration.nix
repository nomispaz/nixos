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
  networking.hostName = "vmqemu";

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      i3status
      rofi
      dunst
    ];
  };

  # use when a new kernel needs to be compiled for the trekstor device. The kernel is compiled on a different pc within the vm and then copied to the trekstor device
  # required so that the silead touchscreen is calibrated correctly
  boot.kernelPatches = [ {
        name = "touch screen support";
        patch = null;
        extraStructuredConfig = with lib.kernel; {
            TOUCHSCREEN_DMI = yes;
  	    EFI_EMBEDDED_FIRMWARE = yes;
          };                
  } ];

}

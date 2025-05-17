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

 hardware.firmware = [
   (pkgs.runCommand "gsl1680-trekstor-primebook-c13" { } ''
     mkdir -p $out/lib/firmware/silead
     cp -r ${./gsl1680-trekstor-primebook-c13.fw} $out/lib/firmware/silead/mssl1680.fw
   '')
 ];

  # define hostname
  networking.hostName = "trekstor";

}

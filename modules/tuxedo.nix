{ config, pkgs, lib, ... }:

{

  imports = [
    #../packages/tuxedo-keyboard/tuxedo-keyboard.nix
    #../packages/tuxedo-control-center/tuxedo-control-center.nix
    #../packages/tuxedo-drivers/tuxedo-drivers.nix
  ];

  #disabledModules = [ "hardware/tuxedo-keyboard.nix" ];

  #hardware = {
  #  tuxedo-keyboard.enable = true;
  #  tuxedo-drivers.enable = true;
  #};

  services.udev.extraRules = builtins.readFile ../packages/tuxedo-drivers/99-z-tuxedo-systemd-fix.rules;

  environment.systemPackages = with pkgs; [
    #(config.boot.kernelPackages.callPackage ../packages/tuxedo-control-center {})
  ];

  #hardware.tuxedo-control-center = {
  #  enable = true;
  #};

 #hardware.tuxedo-rs = {
 #   enable = true;
 #   tailor-gui.enable = true;
 # };

}

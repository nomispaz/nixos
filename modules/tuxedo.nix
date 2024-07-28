{ config, pkgs, lib, ... }:

{

  disabledModules = [ "hardware/tuxedo-keyboard.nix" ];

  imports = [
#    ../packages/tuxedo-drivers/tuxedo-drivers.nix
  ];

  boot = {
    kernelParams = [
      "tuxedo_keyboard.mode=0"
      "tuxedo_keyboard.brightness=25"
      "tuxedo_keyboard.color_left=0x0000ff"
    ];
  };

  hardware = {
    tuxedo-drivers.enable = true;
  };

  #environment.systemPackages = with pkgs; [
    #linuxKernel.packages.linux_latest.tuxedo-keyboard
 #   curl (callPackage ../packages/tuxedo-drivers/default.nix {})
  #];

  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };


}

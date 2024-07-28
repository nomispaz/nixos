{ config, pkgs, lib, ... }:

{

  disabledModules = [ "hardware/tuxedo-keyboard.nix" ];

  imports = [
#    ../packages/tuxedo-drivers/tuxedo-drivers.nix
  ];

  hardware = {
    tuxedo-drivers.enable = true;
  };

#  environment.systemPackages = with pkgs; [
    #linuxKernel.packages.linux_latest.tuxedo-keyboard
#    curl (callPackage ../packages/tuxedo-drivers/default.nix {})
    #nixpkgs-nomispaz.tuxedo-drivers
#  ];

  hardware.tuxedo-rs = {
    enable = true;
    tailor-gui.enable = true;
  };


}

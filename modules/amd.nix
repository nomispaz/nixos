{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ 
    "amdgpu"
  ];

  hardware = {
    cpu.amd.updateMicrocode = true;
   };

  # enable amd-pstate mode
  boot = {
    kernelParams = [
      "amd_pstate=active"
    ];
  };

  # enable zenpower
  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
  boot.kernelModules = [ "zenpower" ];

  # enable tlp
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;

}

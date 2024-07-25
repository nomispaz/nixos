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

}

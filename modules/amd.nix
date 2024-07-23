{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ 
    "amdgpu"
  ];

}

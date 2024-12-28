{config, pkgs, lib, ... }:

{
  imports = [
  ];

  # linux kernel
  boot = {
    kernelPackages = pkgs.unstable.linuxPackages_6_12;
    kernelParams = [
      "mitigations=auto"
      "security=apparmor"
    ];
  };

}

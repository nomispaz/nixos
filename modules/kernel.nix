{config, pkgs, lib, ... }:

{
  imports = [
  ];

  # linux kernel
  boot = {
    kernelPackages = pkgs.unstable.linuxPackages_6_10;
    kernelParams = [
      "mitigations=auto"
      "security=apparmor"
    ];
  };

}

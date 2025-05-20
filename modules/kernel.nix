{config, pkgs, lib, ... }:

{
  imports = [
  ];

  # linux kernel
  boot = {
    #kernelPackages = pkgs.unstable.linuxPackages_latest;
    kernelParams = [
      "mitigations=auto"
      "security=apparmor"
    ];
  };

}

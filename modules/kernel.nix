{config, pkgs, lib, ... }:

{
  imports = [
  ];

  # linux kernel
  boot = {
    #kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxPackages_6_14;
    kernelParams = [
      "mitigations=auto"
      "amd_pstate=active"
    # disabled since in 25.05, this cannot be added to kernel if activated in security
    #  "security=apparmor"
    ];
  };

}

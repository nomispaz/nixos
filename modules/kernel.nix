{config, pkgs, lib, ... }:

{
  imports = [
  ];

  # linux kernel
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "mitigations=auto"
      "amd_pstate=active"
    # disabled since in 25.05, this cannot be added to kernel if activated in security
    #  "security=apparmor"
    ];
  };

}

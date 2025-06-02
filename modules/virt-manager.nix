{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = true;
      ovmf = {
        enable = true;
      };
      swtpm.enable = true;
    };
  };

  users.users.simonheise = {
    extraGroups = [ "libvirtd"];
  };


}

{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;

  users.users.simonheise = {
    extraGroups = [ "libvirt"];
  };


}

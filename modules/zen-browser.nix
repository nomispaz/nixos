{config, pkgs, lib, inputs, ... }:
{

imports = [
  ];

environment.systemPackages = with pkgs; [
    inputs.nomispaz-localrepo.packages.x86_64-linux.zen-browser-bin
  ];
}

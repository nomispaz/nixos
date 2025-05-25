{config, pkgs, lib, inputs, ... }:
{

imports = [
  ];

environment.systemPackages = with pkgs; [
  inputs.nomispaz-linutil.packages.x86_64-linux.linutil
  inputs.nomispaz-cpupower_go.packages.x86_64-linux.cpupower_go
  ];
}

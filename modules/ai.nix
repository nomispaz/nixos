{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    ollama-cuda
  ];

}

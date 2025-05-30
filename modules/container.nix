# https://nixos.wiki/wiki/Podman
{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
   
    };
  };

  hardware.nvidia-container-toolkit.enable = true;
}

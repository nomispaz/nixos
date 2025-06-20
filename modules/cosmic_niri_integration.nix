{config, pkgs, lib, inputs, ... }:
{

imports = [
  ];

environment.systemPackages = with pkgs; [
    inputs.nomispaz-localrepo.packages.x86_64-linux.cosmic-ext-niri-session
    inputs.nomispaz-localrepo.packages.x86_64-linux.cosmic-ext-alternative-startup
  ];

  services.displayManager.sessionPackages = [ inputs.nomispaz-localrepo.packages.x86_64-linux.cosmic-ext-niri-session ];

}

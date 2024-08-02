{config, pkgs, lib, ... }:

{
  imports = [
  ];

  programs.steam = {
      enable = true;
      package = pkgs.unstable.steam;
  };

  environment.systemPackages = with pkgs; [
    unstable.winetricks
    unstable.wine
    unstable.mangohud
    unstable.lutris
  ];

}

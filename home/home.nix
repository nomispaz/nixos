{ config, pkgs, ... }:
{

  home = {
    username = "simonheise";
    homeDirectory = "/home/simonheise";
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "nomispaz";
    userEmail = "nomispaz@example.org";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };
}

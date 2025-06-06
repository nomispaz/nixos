{ config, pkgs, ... }:
let
  username = "simonheise";
  homeDirectory = "/home/simonheise";
in
{

  home = {
    username = "${username}";
    homeDirectory = "${homeDirectory}";
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #####################################################################
  # Git
  #####################################################################
  
  # allow saving of git credentials in keyring by activating "withLisecret"
  home.file."${homeDirectory}/.config/git/config".text = ''
  [credential]
	helper = "${
    pkgs.git.override { withLibsecret = true; }
    }/bin/git-credential-libsecret";

  [user]
	email = "nomispaz@example.org"
	name = "nomispaz"
  '';

  #####################################################################
  # Alacritty
  #####################################################################
  
  home.file."${homeDirectory}/.config/alacritty/alacritty.toml".text = ''
    [font]
    size = 16.0

    [font.bold]
    family = "DejaVu Sans Mono"
    style = "Bold"
    
    [font.bold_italic]
    family = "DejaVu Sans Mono"
    style = "Bold Italic"
    
    [font.italic]
    family = "DejaVu Sans Mono"
    style = "Italic"
    
    [font.normal]
    family = "DejaVu Sans Mono"
    style = "Regular"
    
    [general]
    live_config_reload = true
    
    [terminal.shell]
    program = "fish"
  '';
  
}

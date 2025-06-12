{ config, pkgs, lib, builtins, ... } @args:
let
  username = "simonheise";
  homeDirectory = "/home/simonheise";
  currentDistro = args.distro;
in
{

  home = {
    username = "${username}";
    homeDirectory = "${homeDirectory}";
    stateVersion = "25.05";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  ####################################################################
  # Source all dotfiles available in the file structure that are not specifically changed here
  #####################################################################

    home.file."${homeDirectory}/.config/" = {
      source = ./dotfiles/.config;
      recursive = true;
    };

 
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

    

  #####################################################################
  # Docker and podman
  #####################################################################

  # activate nvidia for containers
  home.file."${homeDirectory}/.config/containers/containers.conf".text = ''
    [containers]
    annotations=["run.oci.keep_original_groups=1",]
  '';
  
  home.file."${homeDirectory}/.config/containers/storage.conf".text = ''
    [storage]
    driver = "overlay"
    graphroot = "${homeDirectory}/data/podman"
  '';

}

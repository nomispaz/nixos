{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    btrfs-progs
    vim
    #emacs
    ((emacsPackagesFor emacs).emacsWithPackages (
      epkgs: [ epkgs.catppuccin-theme
	       epkgs.yasnippet
	       epkgs.yasnippet-snippets
	       epkgs.company
	       epkgs.consult
	       epkgs.breadcrumb
	       epkgs.go-mode
	       epkgs.rust-mode
	       epkgs.evil
	]
    ))
    screenfetch
    gcc
    wget
    alacritty
    python3
    curl
    gnugrep
    xdg-utils
    xdg-user-dirs
    snapper
    egl-wayland
    keepassxc
    veracrypt
    vlc
    testdisk
    meld
    ranger
    font-awesome
    linuxPackages.cpupower
    brave
    networkmanagerapplet
    go
    gopls
    pciutils
    ripgrep
    rustup
  ];

  # configs for programs
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.unstable.neovim-unwrapped;
      withPython3 = true;
    };
    git = {
      enable = true;
    };
    fish.enable = true;
    htop.enable = true;
    firefox = {
      enable = true;
      policies = {
        Extensions = {
          # Enforce the installation of Privacy Badger and uBlock Origin
          Install = [
            "https://addons.mozilla.org/firefox/downloads/file/4321653/privacy_badger17-latest.xpi"
            "https://addons.mozilla.org/firefox/downloads/file/4391011/ublock_origin-latest.xpi"
          ];
        };
    };
    };
  };

  services.flatpak.enable = true;


}

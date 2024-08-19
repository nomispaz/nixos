{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
    btrfs-progs
    vim
    emacs
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
    linuxKernel.packages.linux_6_10.cpupower
    brave
    networkmanagerapplet
    go
    gopls
    pciutils
    kdePackages.kwallet-pam
    ripgrep
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
    firefox.enable = true;

  };

  services.flatpak.enable = true;


}

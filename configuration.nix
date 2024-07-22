# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  fileSystems."/".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  fileSystems."/.snapshots".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  fileSystems."/home".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  fileSystems."/nix".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  fileSystems."/var/log".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  # Bootloader.
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };

  # activate flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # linux kernel
  boot.kernelPackages = pkgs.linuxPackages_6_9;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # chrony
  services.chrony.enable = true;

  # Enable the gnome-keyring
  services.gnome.gnome-keyring.enable = true;

  # enable sway
  programs = {

    sway = {
      enable = true;
      package = pkgs.sway;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        wl-clipboard
        grim
        slurp
        swaybg
        dunst
        gammastep
        python311Packages.i3ipc
        rofi
        brightnessctl
        pavucontrol
        wlroots
	waybar
      ];
      extraOptions = [
        "--unsupported-gpu"
      ];
      extraSessionCommands = 
        ''
          export WLR_NO_HARDWARE_CURSORS=1
        '';
    };
  };
  xdg.portal.wlr.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "de";
    xkb.variant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # config for hardware

  hardware = {
    tuxedo-keyboard.enable = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;
    tuxedo-rs.enable = true;
    # Disable pulseaudio since pipewire should be used
    pulseaudio.enable = false;
  };

  # config for services

  # configure pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  security = {
    rtkit.enable = true;
    apparmor = {
      enable = true;
      packages = with pkgs; [
        apparmor-profiles
      ];
    };
    sudo = {
      enable = true;
      extraConfig = 
      ''
      Defaults targetpw
      '';
    };
    loginDefs.settings = {
      SHA_CRYPT_MIN_ROUNDS = 500000;
      SHA_CRYPT_MAX_ROUNDS = 500000;
    };
  };

  systemd.coredump = {
    enable = true;
    extraConfig = 
    ''
    Storage=none
    '';
  };

  services.clamav = {
    scanner.enable = true;
    updater.enable = true;
  };

  

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simonheise = {
    isNormalUser = true;
    home = "/home/simonheise";
    initialPassword = "1";
    description = "Simon Heise";
    extraGroups = [ "networkmanager" "wheel" "libvirt" "simonheise" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # configs for programs
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.neovim-unwrapped;
      withPython3 = true;
    };
    git.enable = true;
    fish.enable = true;
    htop.enable = true;
    firefox.enable = true;

    # gaming
    steam = {
      enable = true;
      extraPackages = with pkgs; [
        gamemode
        winetricks
        wine
        mangohud
      ];
    };

    # virtualization
    virt-manager.enable = true;

  };

  virtualisation.libvirtd.enable = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    blueman
    snapper
    egl-wayland
    calibre
    clipgrab
    discord
    keepassxc
    obs-studio
    thunderbird
    veracrypt
    vlc
    flatpak
    testdisk
    meld
    libreoffice
    ranger
    font-awesome
    linuxKernel.packages.linux_6_9.cpupower
    brave
  ];


  # Set the default editor to vim
  environment.variables.EDITOR = "nvim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  #firewall
  networking.nftables.enable = true;
  networking.firewall = {
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
    enable = true;
  };

  system.stateVersion = "24.05";

}

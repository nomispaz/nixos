# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./filesystems.nix
    ];

# define hostname
  networking.hostName = "xmgneo15";

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
  boot = {
    kernelPackages = pkgs.linuxPackages_6_10;
    kernelParams = [
      "mitigations=auto"
      "security=apparmor"
    ];
  };

  #powerManagement = {
  #  enable = true;
  #  cpuFreqGovernor = "powersave";
  #};

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
          ## Export Environment Variables
          export XDG_SESSION_TYPE=wayland
          export XDG_SESSION_DESKTOP=sway
          export XDG_CURRENT_DESKTOP=sway
          export XDG_CURRENT_SESSION=sway

          ## Qt environment
          export QT_QPA_PLATFORMTHEME=qt6ct
          export QT_AUTO_SCREEN_SCALE_FACTOR=1
          export QT_QPA_PLATFORM=xcb
          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

          # Hardware cursors not yet working on wlroots
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
    enableRedistributableFirmware = true;
    # Disable pulseaudio since pipewire should be used
    pulseaudio.enable = false;
    # bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
      };
  
  #blueman for bluetooth
  services.blueman.enable = true;

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
    git = {
      enable = true;
    };
    fish.enable = true;
    htop.enable = true;
    firefox.enable = true;

  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btrfs-progs
    stable.vim
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
    flatpak
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

  # enable opengl and vpdau/vpaapi
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
    ];
    enable32Bit = true;
  };

  #nvidia hardware PCI-IDs for nvidia-offload
  hardware.nvidia = {
    prime = {
     nvidiaBusId = "PCI:1:0:0";
     amdgpuBusId = "PCI:6:0:0";
    };
  };

  system.stateVersion = "24.05";

}

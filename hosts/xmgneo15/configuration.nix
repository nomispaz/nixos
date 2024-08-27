# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../filesystems.nix
    ];

  # file system of second ssd
  fileSystems."/mnt/nvme2" =
    { device = "/dev/disk/by-uuid/5478d2bc-1d51-467f-b488-87fed42efffb";
      fsType = "btrfs";
      options = [        
	"rw"
        "noatime"
        "compress=zstd:3"
        "ssd"
        "discard=async"
        "space_cache=v2"
      ];
    };

  fileSystems."/mnt/nvme2_xfs" =
    { device = "/dev/disk/by-uuid/ce299340-d7ca-48fc-9320-d8ebaeb23898";
      fsType = "xfs";
      options = [        
	"defaults"
	"noatime"
      ];
    };

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
    extraModprobeConfig = ''
      options tuxedo-keyboard kbd_backlight_mode=0
    '';
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

  # enable sway on nvidia
  programs.sway.extraOptions = [
        "--unsupported-gpu"
  ];
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
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # Set the default editor to vim
  environment.variables.EDITOR = "nvim";

  #firewall
  networking.nftables.enable = true;
  networking.firewall = {
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
    enable = true;
    trustedInterfaces = [ "virbr0" ];
  };

  # enable opengl and vpdau/vpaapi
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
    ];
    driSupport32Bit = true;
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

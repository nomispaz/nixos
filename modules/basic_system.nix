{ config, pkgs, lib, ... }:
{

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

  #powerManagement = {
  #  enable = true;
  #  cpuFreqGovernor = "powersave";
  #};

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

# chrony
  services.chrony.enable = true;

  # Enable the gnome-keyring
  services.gnome.gnome-keyring.enable = true;

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

    # bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  # Disable pulseaudio since pipewire should be used
  services.pulseaudio.enable = false;
  
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
  #  allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
    enable = true;
    trustedInterfaces = [ "virbr0" ];
  };

  # enable opengl and vpdau/vpaapi
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
    enable32Bit = true;
  };

  # enable nfts
  boot.supportedFilesystems = [ "ntfs" ];

  #fonts
  fonts.packages = with pkgs; [ 
    font-awesome
    dejavu_fonts
  ];

  # automatically optimise nix store
  nix.optimise.automatic = true;

  system.stateVersion = "24.11";

}

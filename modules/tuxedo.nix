{ config, pkgs, lib, ... }:

{

  disabledModules = [ "hardware/tuxedo-keyboard.nix" ];

  hardware = {
    tuxedo-drivers.enable = true;
  };

  services.udev.extraRules =
  ''
    SUBSYSTEM=="leds", KERNEL=="*kbd_backlight*", TAG-="systemd"
    SUBSYSTEM=="leds", KERNEL=="*kbd_backlight", TAG+="systemd"
    SUBSYSTEM=="leds", KERNEL=="*kbd_backlight_1", TAG+="systemd"
    SUBSYSTEM=="leds", KERNEL=="*kbd_backlight_2", TAG+="systemd"
    SUBSYSTEM=="leds", KERNEL=="*kbd_backlight_3", TAG+="systemd"
  '';

#hardware.tuxedo-rs = {
  #  enable = true;
  #  tailor-gui.enable = true;
  #};


}

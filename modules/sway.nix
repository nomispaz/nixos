{config, pkgs, lib, ... }:
{
  imports =
    [ 
    ];

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


}

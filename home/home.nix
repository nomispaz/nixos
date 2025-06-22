{ config, pkgs, lib, ... } @args:
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

   # home.file."${homeDirectory}/.config/" = {
   #   source = ./dotfiles/.config;
   #   recursive = true;
   # };

 
  #####################################################################
  # Git
  #####################################################################
    
  # # allow saving of git credentials in keyring by activating "withLisecret"  
  # home.file."${homeDirectory}/.config/git/config".text = ''
  # [credential]
	# helper = libsecret";

  # [user]
	# email = "nomispaz@example.org"
	# name = "nomispaz"

  # [diff]
  # tool = vimdiff

  # [difftool]
  # prompt = false
  # '';

  # #####################################################################
  # # Alacritty
  # #####################################################################
  # 
  # home.file."${homeDirectory}/.config/alacritty/alacritty.toml".text = ''
  #   [font]
  #   size = 16.0

  #   [font.bold]
  #   family = "DejaVu Sans Mono"
  #   style = "Bold"
  #   
  #   [font.bold_italic]
  #   family = "DejaVu Sans Mono"
  #   style = "Bold Italic"
  #   
  #   [font.italic]
  #   family = "DejaVu Sans Mono"
  #   style = "Italic"
  #   
  #   [font.normal]
  #   family = "DejaVu Sans Mono"
  #   style = "Regular"
  #   
  #   [general]
  #   live_config_reload = true
  #   
  #   [terminal.shell]
  #   program = "fish"
  # '';

  #####################################################################
  # Docker and podman
  #####################################################################

  ## activate nvidia for containers
  #home.file."${homeDirectory}/.config/containers/containers.conf".text = ''
  #  [containers]
  #  annotations=["run.oci.keep_original_groups=1",]
  #'';
  #
  #home.file."${homeDirectory}/.config/containers/storage.conf".text = ''
  #  [storage]
  #  driver = "overlay"
  #  graphroot = "${homeDirectory}/data/podman"
  #'';

  ######################################################################
  ## Docker and podman
  ######################################################################

  #home.file."${homeDirectory}/.config/niri/config.kdl".text = ''
  #// https://github.com/YaLTeR/niri/wiki/Configuration:-Introduction
  #
  #// https://github.com/YaLTeR/niri/wiki/Configuration:-Input
  #input {
  #    keyboard {
  #        xkb {
  #	    layout "de"
  #	    options "caps:ctrl_modifier"
  #        }
  #
  #        // Enable numlock on startup, omitting this setting disables it.
  #        numlock
  #    }
  #
  #    // Next sections include libinput settings.
  #    // Omitting settings disables them, or leaves them at their default values.
  #    touchpad {
  #        // off
  #        tap
  #        // natural-scroll
  #	disabled-on-external-mouse
  #    }
  #
  #    mouse {
  #        // off
  #        // natural-scroll
  #    }
  #
  #    // make the mouse warp to the center of newly focused windows.
  #    warp-mouse-to-focus
  #
  #    // Focus windows and outputs automatically when moving the mouse into them.
  #    // Setting max-scroll-amount="0%" makes it work only on windows already fully on screen.
  #    // focus-follows-mouse max-scroll-amount="0%"
  #
  #    // Define mod-key depending if running within other compositor or standalone
  #    mod-key "Super"
  #    mod-key-nested "Alt"
  #}
  #
  #// https://github.com/YaLTeR/niri/wiki/Configuration:-Outputs
  #output "eDP-1" {
  #    // off
  #
  #    mode "2560x1440@240.000"
  #
  #    scale 1
  #
  #    // normal, 90, 180, 270, flipped, flipped-90, flipped-180 and flipped-270.
  #    transform "normal"
  #}
  #
  #// https://github.com/YaLTeR/niri/wiki/Configuration:-Layout
  #layout {
  #    gaps 2
  #
  #    center-focused-column "never"
  #
  #    // You can customize the widths that "switch-preset-column-width" (Mod+R) toggles between.
  #    preset-column-widths {
  #        // The default preset widths are 1/3, 1/2 and 2/3 of the output.
  #        proportion 0.33333
  #        proportion 0.5
  #        proportion 0.66667
  #    }
  #
  #    // You can change the default width of the new windows.
  #    default-column-width { proportion 0.5; }
  #
  #    // You can change how the focus ring looks.
  #    focus-ring {
  #        // off
  #        width 2
  #
  #	// Color of the ring on the active monitor.
  #        active-color "#7fc8ff"
  #
  #        // Color of the ring on inactive monitors.
  #        inactive-color "#505050"
  #    }
  #
  #    border {
  #        // If you enable the border, you probably want to disable the focus ring.
  #        off
  #
  #        width 2
  #        active-color "#ffc87f"
  #        inactive-color "#505050"
  #
  #        // Color of the border around windows that request your attention.
  #        urgent-color "#9b0000"
  #    }
  #}
  #
  #// Autostart
  #// spawn-at-startup "waybar"
  #// 
  #
  #// https://github.com/Drakulix/cosmic-ext-extra-sessions/tree/main/niri
  #spawn-at-startup "cosmic-ext-alternative-startup"
  #spawn-at-startup "${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome"
  #spawn-at-startup "${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk"
  #
  #// enable x11
  #spawn-at-startup "xwayland-satellite"
  #environment {
  #    DISPLAY ":0"
  #}
  #
  #// background image
  #// spawn-at-startup "swaybg" "-m" "fill" "-i" "${homeDirectory}/.config/sway/background/wald.jpg"
  #
  #// ask apps to ignore client side decoration if possible. hides title bars if possible
  #prefer-no-csd
  #
  #// path for screenshots
  #screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
  #
  #// Animation settings.
  #// https://github.com/YaLTeR/niri/wiki/Configuration:-Animations
  #animations {
  #    // off
  #}
  #
  #// Window rules
  #// https://github.com/YaLTeR/niri/wiki/Configuration:-Window-Rules
  #// Open the Firefox picture-in-picture player as floating by default.
  #window-rule {
  #    // This app-id regular expression will work for both:
  #    // - host Firefox (app-id is "firefox")
  #    // - Flatpak Firefox (app-id is "org.mozilla.firefox")
  #    match app-id=r#"firefox$"# title="^Picture-in-Picture$"
  #    open-floating true
  #}
  #
  #window-rule {
  #    match app-id=r#"vlc"#
  #    open-fullscreen false
  #    open-maximized false
  #}
  #
  #window-rule {
  #    geometry-corner-radius 4
  #    clip-to-geometry true
  #}
  #
  #binds {
  #   // "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
  #    // when running as a winit window.
  #    //
  #    // Most actions that you can bind here can also be invoked programmatically with
  #    // `niri msg action do-something`.
  #
  #    // show help
  #    Mod+H { show-hotkey-overlay; }
  #
  #    Mod+Return hotkey-overlay-title="Open a Terminal: alacritty" { spawn "alacritty"; }
  #    //Mod+D hotkey-overlay-title="Run an Application: rofi" { spawn "rofi" "-show" "drun"; }
  #    Mod+D { spawn "cosmic-launcher"; }
  #    Super+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn "swaylock"; }
  #    Super+B hotkey-overlay-title="Start Browser" { spawn "zen"; }
  #    Super+S hotkey-overlay-title="Start steam" { spawn "steam"; }
  #
  #    // The allow-when-locked=true property makes them work even when the session is locked.
  #    XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"; }
  #    XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"; }
  #    XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
  #    XF86AudioMicMute     allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }
  #
  #    // change brightness
  #    XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
  #    XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }
  #
  #    // mute Microphone
  #    Mod+Y allow-when-locked=true { spawn "~/.config/niri/mute_mic.sh"; }
  #
  #    // Open/close the Overview: a zoomed-out view of workspaces and windows.
  #    Mod+O repeat=false { toggle-overview; }
  #
  #    Mod+Q { close-window; }
  #
  #    Mod+Left  { focus-column-left; }
  #    Mod+Down  { focus-window-down; }
  #    Mod+Up    { focus-window-up; }
  #    Mod+Right { focus-column-right; }
  #    
  #    Mod+Shift+Left  { move-column-left; }
  #    Mod+Shift+Down  { move-window-down; }
  #    Mod+Shift+Up    { move-window-up; }
  #    Mod+Shift+Right { move-column-right; }
  #   
  #    Mod+Home { focus-column-first; }
  #    Mod+End  { focus-column-last; }
  #    Mod+Shift+Home { move-column-to-first; }
  #    Mod+Shift+End  { move-column-to-last; }
  #
  #    Mod+Ctrl+Left  { focus-monitor-left; }
  #    Mod+Ctrl+Down  { focus-monitor-down; }
  #    Mod+Ctrl+Up    { focus-monitor-up; }
  #    Mod+Ctrl+Right { focus-monitor-right; }
  #   
  #    Mod+Shift+Ctrl+Left  { move-column-to-monitor-left; }
  #    Mod+Shift+Ctrl+Down  { move-column-to-monitor-down; }
  #    Mod+Shift+Ctrl+Up    { move-column-to-monitor-up; }
  #    Mod+Shift+Ctrl+Right { move-column-to-monitor-right; }
  #
  #    Mod+Page_Down      { focus-workspace-down; }
  #    Mod+Page_Up        { focus-workspace-up; }
  #    Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
  #    Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }
  #
  #    Mod+Shift+Page_Down { move-workspace-down; }
  #    Mod+Shift+Page_Up   { move-workspace-up; }
  #    Mod+Shift+U         { move-workspace-down; }
  #    Mod+Shift+I         { move-workspace-up; }
  #
  #    // You can bind mouse wheel scroll ticks using the following syntax.
  #    // These binds will change direction based on the natural-scroll setting.
  #    //
  #    // To avoid scrolling through workspaces really fast, you can use
  #    // the cooldown-ms property. The bind will be rate-limited to this value.
  #    // You can set a cooldown on any bind, but it's most useful for the wheel.
  #    Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
  #    Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
  #    Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
  #    Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }
  #
  #    Mod+WheelScrollRight      { focus-column-right; }
  #    Mod+WheelScrollLeft       { focus-column-left; }
  #    Mod+Ctrl+WheelScrollRight { move-column-right; }
  #    Mod+Ctrl+WheelScrollLeft  { move-column-left; }
  #
  #    // Usually scrolling up and down with Shift in applications results in
  #    // horizontal scrolling; these binds replicate that.
  #    Mod+Shift+WheelScrollDown      { focus-column-right; }
  #    Mod+Shift+WheelScrollUp        { focus-column-left; }
  #    Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
  #    Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }
  #
  #    // Similarly, you can bind touchpad scroll "ticks".
  #    // Touchpad scrolling is continuous, so for these binds it is split into
  #    // discrete intervals.
  #    // These binds are also affected by touchpad's natural-scroll, so these
  #    // example binds are "inverted", since we have natural-scroll enabled for
  #    // touchpads by default.
  #    // Mod+TouchpadScrollDown { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+"; }
  #    // Mod+TouchpadScrollUp   { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-"; }
  #
  #    Mod+1 { focus-workspace 1; }
  #    Mod+2 { focus-workspace 2; }
  #    Mod+3 { focus-workspace 3; }
  #    Mod+4 { focus-workspace 4; }
  #    Mod+5 { focus-workspace 5; }
  #    Mod+6 { focus-workspace 6; }
  #    Mod+7 { focus-workspace 7; }
  #    Mod+8 { focus-workspace 8; }
  #    Mod+9 { focus-workspace 9; }
  #    Mod+Shift+1 { move-column-to-workspace 1; }
  #    Mod+Shift+2 { move-column-to-workspace 2; }
  #    Mod+Shift+3 { move-column-to-workspace 3; }
  #    Mod+Shift+4 { move-column-to-workspace 4; }
  #    Mod+Shift+5 { move-column-to-workspace 5; }
  #    Mod+Shift+6 { move-column-to-workspace 6; }
  #    Mod+Shift+7 { move-column-to-workspace 7; }
  #    Mod+Shift+8 { move-column-to-workspace 8; }
  #    Mod+Shift+9 { move-column-to-workspace 9; }
  #
  #    // Alternatively, there are commands to move just a single window:
  #    // Mod+Ctrl+1 { move-window-to-workspace 1; }
  #
  #    // Switches focus between the current and the previous workspace.
  #    // Mod+Tab { focus-workspace-previous; }
  #
  #    // The following binds move the focused window in and out of a column.
  #    // If the window is alone, they will consume it into the nearby column to the side.
  #    // If the window is already in a column, they will expel it out.
  #    Mod+BracketLeft  { consume-or-expel-window-left; }
  #    Mod+BracketRight { consume-or-expel-window-right; }
  #
  #    // Consume one window from the right to the bottom of the focused column.
  #    Mod+Comma  { consume-window-into-column; }
  #    // Expel the bottom window from the focused column to the right.
  #    Mod+Period { expel-window-from-column; }
  #
  #    Mod+R { switch-preset-column-width; }
  #    Mod+Shift+R { switch-preset-window-height; }
  #    Mod+Ctrl+R { reset-window-height; }
  #    Mod+F { maximize-column; }
  #    Mod+Shift+F { fullscreen-window; }
  #
  #    // Expand the focused column to space not taken up by other fully visible columns.
  #    // Makes the column "fill the rest of the space".
  #    Mod+Ctrl+F { expand-column-to-available-width; }
  #
  #    Mod+C { center-column; }
  #
  #    // Center all fully visible columns on screen.
  #    Mod+Ctrl+C { center-visible-columns; }
  #
  #    // Finer width adjustments.
  #    Mod+Minus { set-column-width "-10%"; }
  #    Mod+Plus { set-column-width "+10%"; }
  #
  #    // Finer height adjustments when in column with other windows.
  #    Mod+Shift+Minus { set-window-height "-10%"; }
  #    Mod+Shift+Plus { set-window-height "+10%"; }
  #
  #    // Move the focused window between the floating and the tiling layout.
  #    Mod+V       { toggle-window-floating; }
  #    Mod+Shift+V { switch-focus-between-floating-and-tiling; }
  #
  #    // Toggle tabbed column display mode.
  #    Mod+W { toggle-column-tabbed-display; }
  #
  #    Print { screenshot; }
  #    Ctrl+Print { screenshot-screen; }
  #    Alt+Print { screenshot-window; }
  #
  #    // Shortcut to escape apps that try to capture all keypresses
  #    // The allow-inhibiting=false property can be applied to other binds as well,
  #    // which ensures niri always processes them, even when an inhibitor is active.
  #    Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
  #
  #    // The quit action will show a confirmation dialog to avoid accidental exits.
  #    Mod+Shift+E { quit; }
  #    Ctrl+Alt+Delete { quit; }
  #}   
  #'';
  #
  #home.file."${homeDirectory}/.config/niri/mute_mic.sh" = {
  #  text = ''
  #    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && dunstctl close-all && dunstify "mic $(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo muted || echo unmuted)"
  #  '';
  #  executable = true;
  #};

  # home.file."${homeDirectory}/.config/niri_test/config.kdl".text =
  #   builtins.replaceStrings ["/usr/libexec/xdg-desktop-portal-gnome"] ["${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gnome"]
  #     (builtins.readFile "../home/config.kdl");
  #home.file."${homeDirectory}/.config/niri_test/config.kdl".text =
  #  builtins.replaceStrings ["/usr/libexec/xdg-desktop-portal-gtk"] ["${pkgs.xdg-desktop-portal-gnome}/libexec/xdg-desktop-portal-gtk"]
  #    (builtins.readFile "${homeDirectory}/.config/niri/config.kdl");
}

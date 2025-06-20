{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
 , stdenv ? pkgs.stdenv
 , fetchurl ? pkgs.fetchurl
 , lib ? pkgs.lib
 , dbus
 }:

stdenv.mkDerivation rec {
  pname = "cosmic-ext-niri-session";
  version = "1.0.0";
  rev = 4;

  # create desktop-file
  desktop-file = pkgs.writeText "cosmic-ext-niri.desktop" ''
    [Desktop Entry]
    Name=COSMIC-on-niri
    Comment=This session logs you into the COSMIC desktop on niri
    Exec=/run/current-system/sw/bin/start-cosmic-ext-niri
    Type=Application
    DesktopNames=cosmic-niri
  '';

  start-file = pkgs.writeShellScriptBin "start-cosmic-ext-niri" ''
    #!${pkgs.bash}/bin/bash
    		
    set -e
    
    # From: https://people.debian.org/~mpitt/systemd.conf-2016-graphical-session.pdf
    
    if command -v systemctl >/dev/null; then
        # robustness: if the previous graphical session left some failed units,
        # reset them so that they don't break this startup
        for unit in $(systemctl --user --no-legend --state=failed --plain list-units | cut -f1 -d' '); do
            partof="$(systemctl --user show -p PartOf --value "$unit")"
            for target in cosmic-session.target graphical-session.target; do
                if [ "$partof" = "$target" ]; then
                    systemctl --user reset-failed "$unit"
                    break
                fi
            done
        done
    fi
    
    # use the user's preferred shell to acquire environment variables
    # see: https://github.com/pop-os/cosmic-session/issues/23
    if [ -n "''${SHELL}" ]; then
        # --in-login-shell: our flag to indicate that we don't need to recurse any further
        if [ "''${1}" != "--in-login-shell" ]; then
            # `exec -l`: like `login`, prefixes $SHELL with a hyphen to start a login shell
            exec bash -c "exec -l ''\'''${SHELL}''\' -c ''\'''${0} --in-login-shell'"
        fi
    fi
    
    export XDG_CURRENT_DESKTOP="''${XDG_CURRENT_DESKTOP:=niri}"
    export XDG_SESSION_TYPE="''${XDG_SESSION_TYPE:=wayland}"
    export XCURSOR_THEME="''${XCURSOR_THEME:=Cosmic}"
    export _JAVA_AWT_WM_NONREPARENTING=1
    export GDK_BACKEND=wayland,x11
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM="wayland;xcb"
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_ENABLE_HIGHDPI_SCALING=1
    
    if command -v systemctl >/dev/null; then
        # set environment variables for new units started by user service manager
        systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP
    fi
    # Run cosmic-session
    if [[ -z "''${DBUS_SESSION_BUS_ADDRESS}" ]]; then
        exec ${lib.getBin dbus}/dbus-run-session -- ${pkgs.cosmic-session}/bin/cosmic-session niri
    else
        exec ${pkgs.cosmic-session}/bin/cosmic-session niri
    fi
  '';

  phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/share/wayland-sessions
    cp ${desktop-file} $out/share/wayland-sessions/cosmic-ext-niri.desktop
    cp ${start-file}/bin/start-cosmic-ext-niri $out/bin/
    runHook postInstall
  '';

passthru.providedSessions = [ "cosmic-ext-niri" ];

}


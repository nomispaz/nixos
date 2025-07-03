 { pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
 , stdenv ? pkgs.stdenv
 , fetchurl ? pkgs.fetchurl
 , lib ? pkgs.lib
 }:

stdenv.mkDerivation rec {
  pname = "zen-browser-bin";
  version = "1.13.2b";
  rev = 1;

  src = fetchTarball {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.xz";
    sha256 = "sha256:0hmb3zxjn961nd6c0ry5mbcr2iq38i1rvqs31qg99c7mcsv6zjal";
  };

  nativeBuildInputs = [ pkgs.makeWrapper pkgs.copyDesktopItems pkgs.wrapGAppsHook ] ;


  runtimeLibs = with pkgs; [
        libGL libGLU libevent libffi libjpeg libpng libstartup_notification libvpx libwebp
        stdenv.cc.cc fontconfig libxkbcommon zlib freetype
        gtk3 libxml2 dbus xcb-util-cursor alsa-lib libpulseaudio pango atk cairo gdk-pixbuf glib
	udev libva mesa libnotify cups pciutils
	ffmpeg libglvnd pipewire
      ] ++ (with pkgs.xorg; [
        libxcb libX11 libXcursor libXrandr libXi libXext libXcomposite libXdamage
	libXfixes libXScrnSaver
      ]);

  sourceRoot = ".";

  # create desktop-file
  desktop-file = pkgs.writeText "zen.desktop" ''
    [Desktop Entry]
    Name=Zen Browser
    Comment=Experience tranquillity while browsing the web without people tracking you!
    Exec=/run/current-system/sw/bin/zen %u
    Icon=zen-browser
    Type=Application
    MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;application/x-xpinstall;application/pdf;application/json;
    StartupWMClass=zen
    Categories=Network;WebBrowser;
    StartupNotify=true
    Terminal=false
    X-MultipleArgs=false
    Keywords=Internet;WWW;Browser;Web;Explorer;
    Actions=new-window
  '';

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt/
    mkdir -p $out/bin
    mkdir -p $out/share/applications/
    cp -r $src/* $out/opt/
    ln -s $out/opt/zen $out/bin/
    cp ${desktop-file} $out/share/applications/
    runHook postInstall
  '';

fixupPhase = ''
  chmod 755 $out/opt/*
  patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen
  wrapProgram $out/opt/zen --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
    --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen-bin
  wrapProgram $out/opt/zen-bin --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
    --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/glxtest
  wrapProgram $out/opt/glxtest --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"
  patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/updater
  wrapProgram $out/opt/updater --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"
  patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/vaapitest
  wrapProgram $out/opt/vaapitest --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"

'';

  meta = with lib; {
    homepage = "https://github.com/zen-browser/desktop";
    description = "Zen is a firefox-based browser with the aim of pushing your productivity to a new level";
    platforms = platforms.linux;
  };
}

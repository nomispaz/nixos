{ lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, makeWrapper ? pkgs.makeWrapper
, fetchurl ? pkgs.fetchurl
, rpmextract ? pkgs.rpmextract
, autoPatchelfHook ? pkgs.autoPatchelfHook
, alsa-lib ? pkgs.alsa-lib
, cups ? pkgs.cups
, gdk-pixbuf ? pkgs.gdk-pixbuf
, glib ? pkgs.glib
, gtk3 ? pkgs.gtk3
, libnotify ? pkgs.libnotify
, libuuid ? pkgs.libuuid
, libX11 ? pkgs.xorg.libX11
, libXScrnSaver ? pkgs.xorg.libXScrnSaver
, libXcomposite ? pkgs.xorg.libXcomposite
, libXcursor ? pkgs.xorg.libXcursor
, libXdamage ? pkgs.xorg.libXdamage
, libXext ? pkgs.xorg.libXext
, libXfixes ? pkgs.xorg.libXfixes
, libXi ? pkgs.xorg.libXi
, libXrandr ? pkgs.xorg.libXrandr
, libXrender ? pkgs.xorg.libXrender
, libXtst ? pkgs.xorg.libXtst
, libxcb ? pkgs.xorg.libxcb
, libxshmfence ? pkgs.xorg.libxshmfence
, mesa ? pkgs.mesa
, nspr ? pkgs.nspr
, nss ? pkgs.nss
, pango ? pkgs.pango
, systemd ? pkgs.systemd
, libappindicator-gtk3 ? pkgs.libappindicator-gtk3
, libdbusmenu ? pkgs.libdbusmenu
, pkgs ? import <nixpkgs> { system = builtins.currentSystem; }

}:

stdenv.mkDerivation rec {
  pname = "tuxedo-control-center";
  version = "2.1.8";

  src = pkgs.fetchurl {
    url = "https://rpm.tuxedocomputers.com/fedora/39/x86_64/base/tuxedo-control-center_${version}.rpm";
    hash = "sha256-idpLXhww+4cd7NS6H78ZQ89KgwwtYI5OMJSPaNZtIp4=";
  };


  nativeBuildInputs = [
    rpmextract
    makeWrapper
    alsa-lib
    autoPatchelfHook
    cups
    libXdamage
    libX11
    libXScrnSaver
    libXtst
    libxshmfence
    mesa
    nss
    libXrender
    gdk-pixbuf
    gtk3
  ];

  libPath = lib.makeLibraryPath [
    alsa-lib
    gdk-pixbuf
    glib
    gtk3
    libnotify
    libX11
    libXcomposite
    libuuid
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    nspr
    nss
    libxcb
    pango
    systemd
    libXScrnSaver
    libappindicator-gtk3
    libdbusmenu
  ];

  unpackPhase = ''
    mkdir -p $out/bin
    cd $out
    rpmextract $src
  '';

  installPhase = ''
    runHook preInstall

    wrapProgram $out/opt/tuxedo-control-center/tuxedo-control-center \
        --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/tuxedo-control-center

    ln -s $out/opt/tuxedo-control-center/tuxedo-control-center $out/bin/
    ln -s $out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/service/tccd $out/bin/


    runHook postInstall
  '';


  meta = with lib; {
    description = "A tool to help you control performance, energy, fan and comfort settings on TUXEDO laptops.";
    homepage = "github.com/tuxedocomputers/tuxedo-control-center";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}

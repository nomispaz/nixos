#{ pkgs, ... }:
{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, stdenv ? pkgs.stdenv
}:


stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-control-center-bin";
  version = "2.1.8";

  src = pkgs.fetchurl {
    url = "https://rpm.tuxedocomputers.com/fedora/39/x86_64/base/tuxedo-control-center_${finalAttrs.version}.rpm";
    hash = "sha256-idpLXhww+4cd7NS6H78ZQ89KgwwtYI5OMJSPaNZtIp4=";
  };

  buildInputs = [
    pkgs.rpmextract
  ];

  unpackPhase = ''
    rpmextract $src
  '';

  installPhase = ''
    cp -av usr $out
    cp -av opt $out
    chmod -R 755 $out/opt/tuxedo-control-center/
    mkdir -p $out/usr/bin  
  ln -sfv /opt/tuxedo-control-center/tuxedo-control-center "$out/usr/bin/tuxedo-control-center"
  install -Dm644 "$out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tuxedo-control-center.desktop" "$out/usr/share/applications/tuxedo-control-center.desktop"
  install -Dm644 "$out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/com.tuxedocomputers.tccd.policy" "$out/usr/share/polkit-1/actions/com.tuxedocomputers.tccd.policy"
  install -Dm644 "$out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/com.tuxedocomputers.tccd.conf" "$out/usr/share/dbus-1/system.d/com.tuxedocomputers.tccd.conf"
  install -Dm644 "$out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tccd.service" "$out/etc/systemd/system/tccd.service"
  install -Dm644 "$out/opt/tuxedo-control-center/resources/dist/tuxedo-control-center/data/dist-data/tccd-sleep.service" "$out/etc/systemd/system/tccd-sleep.service"
  '';
  })

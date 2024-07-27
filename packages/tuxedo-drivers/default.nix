{ pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
, lib ? pkgs.lib
, stdenv ? pkgs.stdenv
, kernel ? pkgs.linux_latest
, fetchFromGitLab ? pkgs.fetchFromGitLab
, fetchpatch ? pkgs.fetchpatch
, kmod ? pkgs.kmod
, pahole ? pkgs.pahole
}:

# { lib, stdenv, fetchFromGitLab, kernel, kmod, pahole }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tuxedo-drivers-${kernel.version}";
  version = "4.6.1";

  src = fetchFromGitLab {
    owner = "tuxedocomputers/development/packages";
    repo = "tuxedo-drivers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hZ4fY6TQj4YIOzFH+iZq90VPr87KIzke4N2PiJGYeEE=";
  };

  patches = [
    (fetchpatch {
      name = "fix-dot-owner.patch";
      url = "https://raw.githubusercontent.com/nomispaz/nixos/155c905820fe54955b02ade084a9c95b6d2409bf/overlays/patches/tuxedo-keyboard/fix-dot-owner.patch";
      hash = "sha256-VO420pPu9wQSJf23p+VcTl1oN2ImVwuoSdBWKA56JpE=";
    })
  ];

  buildInputs = [ pahole ];
  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = {
    broken = stdenv.isAarch64 || (lib.versionOlder kernel.version "5.5");
    description = "Drivers for several platform devices for TUXEDO notebooks";
    homepage = "https://gitlab.com/tuxedocomputers/development/packages/tuxedo-drivers";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      This driver provides support for Fn keys, brightness/color/mode for most TUXEDO
      keyboards (except white backlight-only models) and a hardware I/O driver for
      the TUXEDO Control center.
    '';
    maintainers = [ lib.maintainers.aprl ];
    platforms = lib.platforms.linux;
  };
})

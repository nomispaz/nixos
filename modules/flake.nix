{config, pkgs, lib, ... }:


let
  linutil = pkgs.buildGoModule (finalAttrs: {
    pname = "linutil";
    version = "0.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "nomispaz";
      repo = "linutil";
      rev = "40f26c29e7aca3477522f2fba4f24d1a1c95b2b3";
      #sha256 = lib.fakeSha256;
    };

    vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

    meta = {
      description = "Go program with simple TUI for various linux tasks. Work in progress.";
      homepage = "https://github.com/nomispaz/linutil";
      license = lib.licenses.gpl3;
    };
  });
in
{
environment.systemPackages = with pkgs; [
    linutil
  ];
}
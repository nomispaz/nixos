{
  description = "Nomispaz package repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.zen-browser-bin = pkgs.callPackage ./zen-browser-bin {};
    #packages.${system}.tuxedo-keyboard = pkgs.callPackage ./tuxedo-keyboard {};

    #nixosModules.default = import ./tuxedo-keyboard/tuxedo-keyboard.nix;
  };
}

{
  description = "Nomispaz package repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = [
      (import nixpkgs).pkgs.callPackage ./tuxedo-keyboard {}
      (import nixpkgs).pkgs.callPackage ./linutil {}
    ];
    nixosModules.default = import ./tuxedo-keyboard/tuxedo-keyboard.nix;
  };
}

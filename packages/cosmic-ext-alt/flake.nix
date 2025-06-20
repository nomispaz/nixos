
{
  description = "cosmic niri integration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.cosmic-ext-alt = pkgs.callPackage ./default.nix { };

    defaultPackage.${system} = self.packages.${system}.cosmic-ext-alt;
  };
}


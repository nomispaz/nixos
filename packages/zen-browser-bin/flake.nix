
{
  description = "zen-browser package";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.zen-browser-bin = pkgs.callPackage ./default.nix { };

    defaultPackage.${system} = self.packages.${system}.zen-browser-bin;
  };
}


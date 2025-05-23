{
  description = "Go linutil flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    packages.${system}.linutil = pkgs.buildGoModule {
      pname = "linutil";
      version = "0.1.0";

      src = pkgs.fetchFromGitHub {
        owner = "nomispaz";
        repo = "linutil";
        rev = "40f26c29e7aca3477522f2fba4f24d1a1c95b2b3";
        sha256 = "sha256-HaMgPqRw/NV3ar9X1XRhfVYgP8H3jeroilCVUJH9uRs=";  # for the source archive
      };

      vendorHash = "sha256-W7Aj/Jfr4AgAGYW9TdTUEmUqtWDb1G1kI/LUP6pFNNk=";  # temp hash to get the real one

      preBuild = ''
        export GOWORK=off
      '';

      meta = {
        description = "Go TUI for Linux tasks";
        homepage = "https://github.com/nomispaz/linutil";
        license = pkgs.lib.licenses.gpl3;
      };
    };

    defaultPackage.${system} = self.packages.${system}.linutil;
  };
}

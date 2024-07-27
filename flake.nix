{
  description = "Masterflake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }:
    let
      system = "x86_64-linux";
      overlay-stable = final: prev: {
          stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };    
    in {
      nixConfig = {
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
      };
      nixosConfigurations."xmgneo15" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Overlays-module makes "pkgs.stable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./hosts/xmgneo15/configuration.nix
	  ./modules/users.nix
	  ./modules/nvidia.nix
	  ./modules/amd.nix
	  ./modules/virt-manager.nix
	  ./modules/gaming.nix
	  ./modules/various_programs.nix
        ];
      };
      nixosConfigurations."vmqemu" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Overlays-module makes "pkgs.stable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./hosts/vmqemu/configuration.nix
	  ./modules/users.nix
	];
      };
    };
}

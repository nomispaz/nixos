{
  description = "Masterflake";

  inputs = {
    # NixOS official package source
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
     #nixpkgs-nomispaz = {
     #     url = "./packages";
     #     flake = true;
     #     # Avoid pulling in the nixpkgs that we pin in the tuxedo-nixos repo.
     #     # This should give the least surprises and saves on disk space.
     #     inputs.nixpkgs.follows = "nixpkgs";
     #};
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
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./hosts/xmgneo15/configuration.nix
	  ./modules/users.nix
	  ./modules/nvidia.nix
	  ./modules/amd.nix
	  ./modules/virt-manager.nix
	  ./modules/gaming.nix
	  ./modules/various_programs.nix
	  ./modules/sway.nix
	  ./modules/extrabootentries.nix
	  ./modules/basic_programs.nix
	  ./modules/tuxedo.nix
	];
      };
      nixosConfigurations."vm" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./hosts/vm/configuration.nix
	  ./modules/users.nix
	  ./modules/sway.nix
	  ./modules/basic_programs.nix
	];
      };
      nixosConfigurations."vmqemu" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./hosts/vmqemu/configuration.nix
	  ./modules/users.nix
	  ./modules/sway.nix
	  ./modules/basic_programs.nix
	];
      };
      nixosConfigurations."trekstor" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # Overlays-module makes "pkgs.unstable" available in configuration.nix
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; })
          ./hosts/trekstor/configuration.nix
	  ./modules/users.nix
	  ./modules/sway.nix
	  ./modules/basic_programs.nix
	];
      };
    };
}

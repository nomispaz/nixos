{
  description = "Masterflake";

  #############################################################################################
  #
  # Inputs
  #
  #############################################################################################
  
  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nomispaz-linutil = {
      url = "github:nomispaz/linutil";
      flake = true;
      # Avoid pulling in the nixpkgs that we pin in the repo.
      # This should give the least surprises and saves on disk space.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nomispaz-cpupower_go = {
      url = "github:nomispaz/cpupower_go";
      flake = true;
      # Avoid pulling in the nixpkgs that we pin in the repo.
      # This should give the least surprises and saves on disk space.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  #############################################################################################
  #
  # Outputs to be used in configuration.nix and modules
  #
  #############################################################################################
  
  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-stable, ... } @ inputs:
    let
      system = "x86_64-linux";

      #############################################################################################
      #
      # Overlays
      #
      #############################################################################################

      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
	        inherit system;
	        config.allowUnfree = true;
        };
      };
      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
	        config.allowUnfree = true;
        };
      };

      #############################################################################################
      #
      # Host configurations
      #
      #############################################################################################
      
    in {

      #############################################################################################
      #
      # XMG neo 15 with nvidia and unstable branch
      #
      #############################################################################################
      
      nixosConfigurations."xmgneo15" = nixpkgs.lib.nixosSystem {
        inherit system;
	      specialArgs = { inherit inputs; };
        modules = [

          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable overlay-stable]; })

          # set nixpkgs to unstable only for this host
	        { nixpkgs.config.pkgs = import nixpkgs-unstable;}
          
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
	        ./modules/kernel.nix
	        ./modules/programming.nix
	        ./modules/ai.nix
	        ./modules/gnome.nix
	        ./modules/basic_system.nix
	        ./modules/gnome_keyring.nix
	        ./modules/bootloader.nix
          ./modules/linutil.nix
          ./modules/hyprland.nix
	      ];
      };

      #############################################################################################
      #
      # XMG neo 15 with nvidia and unstable branch to be installed on an external drive
      #
      #############################################################################################
      
      nixosConfigurations."xmgneo15_external_drive" = nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable overlay-stable ]; })
          
          # set nixpkgs to unstable only for this host
	        { nixpkgs.config.pkgs = import nixpkgs-unstable;}
          
          ./hosts/xmgneo15_external_drive/configuration.nix
	        ./modules/users.nix
	        ./modules/nvidia.nix
	        ./modules/amd.nix
	        ./modules/virt-manager.nix
	        ./modules/gaming.nix
	        ./modules/various_programs.nix
	        ./modules/sway.nix
	        ./modules/extrabootentries.nix
	        ./modules/basic_programs.nix
	        ./modules/kernel.nix
	        ./modules/programming.nix
	        ./modules/ai.nix
	        ./modules/gnome.nix
	        ./modules/basic_system.nix
	        ./modules/gnome_keyring.nix
	        ./modules/linutil.nix
          ./modules/hyprland.nix
	      ];
      };

      #############################################################################################
      #
      # to be used under windows in virtualbox
      #
      #############################################################################################
      
      nixosConfigurations."vm" = nixpkgs.lib.nixosSystem {
        inherit system;
	      specialArgs = { inherit inputs; };

        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable overlay-stable ]; })
          ./hosts/xmgneo15_external_drive/configuration.nix
          ./hosts/vm/configuration.nix
	        ./modules/users.nix
	        ./modules/sway.nix
	        ./modules/basic_programs.nix
	        ./modules/kernel.nix
	        ./modules/gnome.nix
	        ./modules/basic_system.nix
	        ./modules/bootloader.nix
	        ./modules/gnome_keyring.nix
          ./modules/linutil.nix
	      ];
      };

      #############################################################################################
      #
      # to be used in vm and qemu
      #
      #############################################################################################
      
      nixosConfigurations."vmqemu" = nixpkgs.lib.nixosSystem {
        inherit system;
	      specialArgs = { inherit inputs; };

        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable overlay-stable ]; })
          ./hosts/xmgneo15_external_drive/configuration.nix
          ./hosts/vmqemu/configuration.nix
	        ./modules/users.nix
	        ./modules/sway.nix
	        ./modules/basic_programs.nix
	        ./modules/kernel.nix
	        ./modules/gnome.nix
	        ./modules/basic_system.nix
	        ./modules/bootloader.nix
	        ./modules/gnome_keyring.nix
          ./modules/linutil.nix
	      ];
      };

      #############################################################################################
      #
      # trekstor laptop with silead touchscreen
      #
      #############################################################################################
      
      nixosConfigurations."trekstor" = nixpkgs.lib.nixosSystem {
        inherit system;
	      specialArgs = { inherit inputs; };

        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable overlay-stable ]; })
          ./hosts/xmgneo15_external_drive/configuration.nix
          ./hosts/trekstor/configuration.nix
	        ./modules/users.nix
	        ./modules/sway.nix
	        ./modules/basic_programs.nix
	        ./modules/kernel.nix
	        ./modules/gnome.nix
	        ./modules/basic_system.nix
	        ./modules/bootloader.nix
	        ./modules/gnome_keyring.nix
          ./modules/linutil.nix
	      ];
      };
    };
}

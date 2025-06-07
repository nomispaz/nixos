{
  description = "Masterflake";

  #############################################################################################
  #
  # Inputs
  # in hosts configuration, "specialArgs = { inherit inputs; };" is used
  # with this, packages of these inputs can be referenced in other nix-files via:
  # inputs.<inputname>.packages.x86_64-linux.<package>
  #
  #############################################################################################
  
  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    nomispaz-linutil = {
      url = "github:nomispaz/linutil";
      flake = true;
      # Avoid pulling in the nixpkgs that we pin in the repo.
      # This should give the least surprises and saves on disk space.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nomispaz-cpupower_go = {
      url = "github:nomispaz/cpupower_go";
      flake = true;
      # Avoid pulling in the nixpkgs that we pin in the repo.
      # This should give the least surprises and saves on disk space.
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # home manager for user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  #############################################################################################
  #
  # Outputs to be used in configuration.nix and modules
  #
  #############################################################################################
  
  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-stable, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";

      #############################################################################################
      #
      # Overlays
      #
      #############################################################################################

      # unstable overlay
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
	        inherit system;
	        config.allowUnfree = true;
        };
      };

      # stable overlay. In addition to the standard nixpkgs with stable packages.
      # used to enable stable packages for hosts that use the unstable branch as a standard
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
      
      nixosConfigurations."xmgneo15" = nixpkgs-unstable.lib.nixosSystem {
        inherit system;
	      specialArgs = { inherit inputs; };
        modules = [

          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable overlay-stable ]; })

          # set nixpkgs to unstable only for this host
	        { nixpkgs.config.pkgs = import nixpkgs-unstable;}
          
          ./hosts/xmgneo15/configuration.nix

          # make home-manager as a module of nixos
          # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          #home-manager.nixosModules.home-manager
          #{
          #  home-manager.useGlobalPkgs = true;
          #  home-manager.useUserPackages = true;

          #  home-manager.users.simonheise = import ./home/home.nix;
          #}        
	      ];
      };

      #############################################################################################
      #
      # XMG neo 15 with nvidia and unstable branch to be installed on an external drive
      #
      #############################################################################################
      
      nixosConfigurations."external_drive" = nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable overlay-stable ]; })
          
          # set nixpkgs to unstable only for this host
	        { nixpkgs.config.pkgs = import nixpkgs-unstable;}
          
          ./hosts/external_drive/configuration.nix
	        
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

          ./hosts/vm/configuration.nix
	        
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
         
          ./hosts/vmqemu/configuration.nix
	       
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

          ./hosts/trekstor/configuration.nix
	        
	      ];
      };
    };
}

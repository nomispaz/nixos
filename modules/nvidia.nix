{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  boot.kernelParams = [ "nvidia_drm.modeset=1" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  
  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
    dynamicBoost.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    #package = unstable.linuxKernel.packages.linux_6_10.nvidia_x11;
    prime = {
      offload = {
        enable = true;
	enableOffloadCmd = true;
	};
    };
  };

  nixpkgs.overlays = [
    # patch wlroots to prevent flickering on external monitor with nvidia
    (final: prev: {
      wlroots_0_17 = prev.wlroots_0_17.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
           (prev.fetchpatch {
	    url = "https://raw.githubusercontent.com/nomispaz/nixos/c7570c47b3b340391a5a6c3f71f4cf9401a46b8a/overlays/patches/wlroots/wlroots-nvidia.patch";
	    hash = "sha256-s9AYejh9hK5x+v+WWGeflgaSmCFBwFNUNMeeeIxfuPo=";
		})
        ];
      });
    })
  ];

}

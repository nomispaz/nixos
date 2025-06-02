# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../filesystems.nix

      # modules
      ../../modules/users.nix
	    ../../modules/nvidia.nix
	    ../../modules/amd.nix
	    ../../modules/virt-manager.nix
	    ../../modules/gaming.nix
	    ../../modules/various_programs.nix
	    ../../modules/sway.nix
	    ../../modules/extrabootentries.nix
	    ../../modules/basic_programs.nix
	    ../../modules/kernel.nix
	    ../../modules/programming.nix
	    ../../modules/container.nix
	    ../../modules/gnome.nix
	    ../../modules/basic_system.nix
	    ../../modules/gnome_keyring.nix
	    ../../modules/bootloader.nix
      ../../modules/linutil.nix
      ../../modules/hyprland.nix
      ../../modules/gpupassthrough.nix
      
    ];

  # file system of second ssd
  fileSystems."/mnt/nvme2" =
    { device = "/dev/disk/by-uuid/5478d2bc-1d51-467f-b488-87fed42efffb";
      fsType = "btrfs";
      options = [        
	      "rw"
        "noatime"
        "compress=zstd:3"
        "ssd"
        "discard=async"
        "space_cache=v2"
        "nofail"
	      "x-systemd.device-timeout=10"
      ];
    };

  fileSystems."/mnt/nvme2_xfs" =
    { device = "/dev/disk/by-uuid/ce299340-d7ca-48fc-9320-d8ebaeb23898";
      fsType = "xfs";
      options = [        
	      "defaults"
	      "noatime"
        "nofail"
	      "x-systemd.device-timeout=10"
      ];
    };

  # arch data subvolume
  fileSystems."/data" =
    { device = "/dev/disk/by-uuid/4ec3f8b8-cf0d-43df-ad57-3c73f08742c9";
      fsType = "btrfs";
      options = [
        "subvol=data"
	      "rw"
        "noatime"
        "compress=zstd:3"
        "ssd"
        "discard=async"
        "space_cache=v2"
        "nofail"
	      "x-systemd.device-timeout=10"
      ];
    };


  # define hostname
  networking.hostName = "xmgneo15";

  # nvidia hardware PCI-IDs for nvidia-offload
  hardware.nvidia = {
    prime = {
     nvidiaBusId = "PCI:1:0:0";
     amdgpuBusId = "PCI:6:0:0";
    };
  };
}

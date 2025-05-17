# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../filesystems.nix
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
      ];
    };

  fileSystems."/mnt/nvme2_xfs" =
    { device = "/dev/disk/by-uuid/ce299340-d7ca-48fc-9320-d8ebaeb23898";
      fsType = "xfs";
      options = [        
	"defaults"
	"noatime"
      ];
    };

# define hostname
  networking.hostName = "xmgneo15";

  # linux kernel
  boot = {
    extraModprobeConfig = ''
      options tuxedo-keyboard kbd_backlight_mode=0
    '';
  };

  #nvidia hardware PCI-IDs for nvidia-offload
  hardware.nvidia = {
    prime = {
     nvidiaBusId = "PCI:1:0:0";
     amdgpuBusId = "PCI:6:0:0";
    };
  };
}

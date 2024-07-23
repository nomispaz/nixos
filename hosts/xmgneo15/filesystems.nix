{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  fileSystems."/".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  fileSystems."/.snapshots".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  fileSystems."/home".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  fileSystems."/nix".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  fileSystems."/var/log".options = [
    "rw"
    "noatime"
    "compress=zstd:3"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

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
}

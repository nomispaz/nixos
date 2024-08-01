{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  # standard fileSystems with btrfs. Layout (subvolumes):
  # root -> /
  # snapshots -> /.snapshots/
  # home -> /home
  # nix -> /nix
  # var_log -> /var/log
  # swap -> /swap
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

  fileSystems."/swap".options = [
    "noatime"
    "ssd"
  ];
  # swap device
  swapDevices = [ { device = "/swap/swapfile"; } ];
}

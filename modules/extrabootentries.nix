{config, pkgs, lib, ... }:
{
  boot.loader.grub.extraEntries =
    ''
    menuentry "Arch Linux" {
      insmod chain
      search --no-floppy --fs-uuid --set=root AD2B-4935
      chainloader /EFI/arch/grubx64.efi
    }
    '';
}

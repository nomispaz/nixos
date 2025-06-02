# https://nixos.wiki/wiki/Specialisation
# https://forum.level1techs.com/t/nixos-vfio-pcie-passthrough/130916

{config, pkgs, lib, inputs, ... }:
{

imports = [
  ];

specialisation.vfio.configuration = {
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
  boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
  boot.extraModprobeConfig = "options vfio-pci ids=10de:24a0,10de:228b";
};

}

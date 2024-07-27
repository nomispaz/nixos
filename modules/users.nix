{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.simonheise = {
    isNormalUser = true;
    home = "/home/simonheise";
    initialPassword = "1";
    description = "Simon Heise";
    extraGroups = [ "networkmanager" "wheel" "simonheise" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

}

{
  pkgs ? import <nixpkgs> { system = builtins.currentSystem; }
  , lib ? pkgs.lib
}:

{
  pet = pkgs.buildGoModule rec {
    pname = "nixosinstaller";
    version = "0.0.1";

    src = ../installer;

    #vendorHash = lib.fakeHash;
    vendorHash = null;

    meta = {
      description = "Simple command-line installer, written in Go";
      license = lib.licenses.mit;
    };
  };
}

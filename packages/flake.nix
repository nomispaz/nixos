{
  description = "Nix nomispaz repository";

  outputs = _: {
    nomispazPackages = let
    in {
      tuxedo-drivers = import ./packages/tuxedo-drivers;
    };
  };    
}

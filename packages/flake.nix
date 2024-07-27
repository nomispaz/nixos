{
  description = "Nix nomispaz repository";

  outputs = _: {
    tuxedo-drivers = import ./packages/tuxedo-drivers;
  };    
}

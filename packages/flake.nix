{
  description = "Nix nomispaz repository";

  outputs = _: {
    nomispazPackages = let
      import = path: path;
    in {
      tuxedo-drivers = import ./packages/tuxedo-drivers;
    };
  };    
}

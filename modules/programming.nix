{ config, pkgs, lib, ... }:

{
  imports = [
  ];

  environment.systemPackages = with pkgs; [
   python312Packages.flake8
   go
   gopls
   delve
   python312Packages.python-lsp-server
   rust-analyzer
   rustc
   cargo
   rustfmt
   mdbook
   vscodium
  ];

}

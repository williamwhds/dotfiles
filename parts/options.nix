{ lib, inputs, ... }:
let
  system = "x86_64-linux";
in
{
  config = {
    #  values shared by every flake-parts module
    _module.args = {
      inherit system;
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import inputs.nixpkgs-unstable { inherit system; };
    };
  };
}

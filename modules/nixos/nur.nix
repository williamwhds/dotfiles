{ lib, inputs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.nur = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.nur = {
    nixpkgs.overlays = [ inputs.nur.overlays.default ];
  };
}

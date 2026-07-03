{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos."packages-terminals" = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos."packages-terminals" = {
    environment.systemPackages = with pkgs; [
      ghostty
      foot
    ];
  };
}

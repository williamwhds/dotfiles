{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos."packages-office" = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos."packages-office" = {
    environment.systemPackages = with pkgs; [
      libreoffice
    ];
  };
}

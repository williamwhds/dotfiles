{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos."packages-media" = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos."packages-media" = {
    environment.systemPackages = with pkgs; [
      kdePackages.kdenlive
      obs-studio
    ];
  };
}

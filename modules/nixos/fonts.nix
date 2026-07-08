{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.fonts = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.fonts = {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];

    fonts.fontconfig.enable = true;
  };
}

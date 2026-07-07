{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.home.quickshell = lib.mkOption { type = types.deferredModule; };

  config.myModules.home.quickshell = {
    programs.quickshell = {
      enable = true;
    };
  };

}

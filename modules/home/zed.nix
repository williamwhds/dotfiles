{ lib, pkgs-unstable, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.home.zed = lib.mkOption { type = types.deferredModule; };

  config.myModules.home.zed = {
    programs.zed-editor = {
      enable = true;
      package = pkgs-unstable.zed-editor;
      installRemoteServer = true;
      extensions = [ "nix" ];
    };
  };
}

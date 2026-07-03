{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.home.mangohud = lib.mkOption { type = types.deferredModule; };

  config.myModules.home.mangohud = {
    programs.mangohud.enable = true;
    xdg.configFile."MangoHud/MangoHud.conf".source = ./mangohud.conf;
  };
}

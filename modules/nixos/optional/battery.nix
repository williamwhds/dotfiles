{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.battery = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.battery = {
    services.power-profiles-daemon.enable = false;

    services.tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 50;
        STOP_CHARGE_THRESH_BAT0 = 70;
      };
    };

    services.upower.enable = true;
  };
}

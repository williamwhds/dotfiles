{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.hardware = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.hardware = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.bluetooth.enable = true;

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };
  };
}

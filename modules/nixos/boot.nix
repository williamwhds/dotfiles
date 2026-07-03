{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.boot = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.boot = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}

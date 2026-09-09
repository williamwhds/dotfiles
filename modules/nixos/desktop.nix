{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.desktop = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.desktop = {
    services.xserver.enable = true;

    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    services.xserver.xkb = {
      layout = "us";
      variant = "intl";
    };

    programs.xwayland.enable = true;

    services.printing.enable = true;

    xdg.portal = {
      enable = true;

      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      config = {
        kde = {
          default = [ "kde" ];
        };
      };
    };

    services.flatpak.enable = true;
    services.flatpak.update.auto = {
      enable = true;
      onCalendar = "weekly";
    };
  };
}

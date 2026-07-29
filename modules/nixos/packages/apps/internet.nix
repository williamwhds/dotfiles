{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules = {
    nixos."packages-internet" = lib.mkOption { type = types.deferredModule; };
    home."packages-internet" = lib.mkOption { type = types.deferredModule; };
  };

  config.myModules = {
    nixos."packages-internet" = {
      environment.systemPackages = with pkgs; [
        proton-vpn # vpn
        wireguard-tools # needed for protonvpn
        tor-browser # tor browser
        mullvad-browser # privacy focused browser
        vesktop # discord client
      ];

      services.flatpak.packages = [
        "app.zen_browser.zen" # main browser
      ];
    };

    home."packages-internet" = {
      xdg.mimeApps.enable = true;

      # force overwrite the old file
      xdg.configFile."mimeapps.list".force = true;

      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
        "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
        "text/html" = "app.zen_browser.zen.desktop";
      };
    };
  };
}

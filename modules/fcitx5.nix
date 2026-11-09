{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules = {
    nixos.fcitx5 = lib.mkOption { type = types.deferredModule; };
    home.fcitx5 = lib.mkOption { type = types.deferredModule; };
  };

  config.myModules = {
    nixos.fcitx5 = {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          settings = {
            inputMethod = {
              "Groups/0" = {
                Name = "Default";
                "Default Layout" = "us";
                DefaultIM = "keyboard-us-intl";
              };
              "Groups/0/Items/0" = {
                Name = "keyboard-us-intl";
                Layout = "";
              };
              GroupOrder = {
                "0" = "Default";
              };
            };
          };
        };
      };

      # Ensures Electron & Chromium apps use Wayland and connect to Wayland IME
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
    };

    home.fcitx5 = {
      # Custom compose rules so ' + c outputs ç and ' + C outputs Ç
      home.file.".XCompose".text = ''
        include "%L"

        <dead_acute> <c> : "ç" U00E7
        <dead_acute> <C> : "Ç" U00C7
      '';
    };
  };
}

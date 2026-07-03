{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.sops = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.sops = {
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";

      # master age key
      age.keyFile = "/var/lib/sops-nix/keys.txt";

      secrets = {
        # the password needs to be available early in the boot process
        "williamwhds-password" = {
          neededForUsers = true;
        };

        "deepseek-api-key" = {
          format = "yaml";
          owner = "williamwhds";
        };

        "google-api-key" = {
          owner = "williamwhds";
        };
      };
    };
  };
}

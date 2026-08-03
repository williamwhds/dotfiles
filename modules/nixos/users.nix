{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.users = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.users = { config, ... }: {
    users.users.williamwhds = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets."williamwhds-password".path;
      shell = pkgs.zsh;
      description = "William Oliveira";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
    };

    nix.settings.trusted-users = [
      "root"
      "williamwhds"
    ];
  };
}

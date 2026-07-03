{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.users = lib.mkOption { type = types.deferredModule; };

  # The module value is a function so `config` resolves in the NixOS eval context.
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
  };
}

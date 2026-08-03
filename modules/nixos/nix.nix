{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.nix = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.nix = {
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      auto-optimise-store = true;

      # binary caches
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep 5 --keep-since 3d";
      flake = "/home/williamwhds/.dotfiles";
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}

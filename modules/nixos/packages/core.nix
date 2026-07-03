{ lib, pkgs, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos."packages-core" = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos."packages-core" = {
    programs.zsh.enable = true;

    programs.appimage.enable = true;
    programs.appimage.binfmt = true;

    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      git
      gh # github cli
      curl
      wget
      fastfetch
      btop
    ];
  };
}

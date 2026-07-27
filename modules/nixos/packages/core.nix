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

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        webkitgtk_4_1
        gdk-pixbuf
        gtk3
        glib
        libsoup_3
      ];
    };

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

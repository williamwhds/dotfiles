{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.noctalia.homeModules.default

    ../../modules/home/shell.nix
    ../../modules/home/niri.nix
    ../../modules/home/noctalia.nix
    ../../modules/home/plasma.nix
    ../../modules/home/zed.nix
  ];

  home.username = "williamwhds";
  home.homeDirectory = "/home/williamwhds";
  home.stateVersion = "25.05";

  home.file =
    builtins.mapAttrs
      (key: value: {
        # setting symlinks outside of Nix Store, this way I don't need to rebuild the config everytime I change these files
        # symlink ~/.dotfiles/{value} to ~/{key}
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/${value}";
      })
      {
        ".config/nvim" = "home/config/nvim";
      };

  # cloning repo to ~/.dotfiles
  home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.dotfiles" ]; then
      ${pkgs.git}/bin/git clone https://github.com/williamwhds/dotfiles "$HOME/.dotfiles"
    fi
  '';

  programs.home-manager.enable = true;
}

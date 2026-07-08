{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  inherit (lib) types;
in
{
  options.myModules.nixos."packages-dev" = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos."packages-dev" = {
    environment.systemPackages = with pkgs; [
      # text editors
      pkgs-unstable.zed-editor
      neovim

      # distrobox
      distrobox
      distroshelf

      # agents
      pkgs-unstable.opencode

      # nix
      nil
      nixd

      # qml (for quickshell / qt6 qml)
      kdePackages.qtdeclarative # includes qmllint and qmlls

      # web / general
      vscode-langservers-extracted
      package-version-server
    ];

    # docker
    virtualisation.docker = {
      enable = true;
    };
  };
}

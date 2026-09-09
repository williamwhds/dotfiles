{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos."packages-dev" = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos."packages-dev" = { pkgs, pkgs-unstable, inputs, ... }: {
    environment.systemPackages = with pkgs; [
      # declarative developer environments
      devenv

      # text editors
      pkgs-unstable.zed-editor
      vscodium
      neovim

      # distrobox
      distrobox
      distroshelf

      # agents
      pkgs-unstable.opencode
      nur.repos.linyinfeng.deepseek-reasonix
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli

      # android
      android-tools

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

{ pkgs, pkgs-unstable, ... }:

{
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

    # web / general
    nodePackages.vscode-langservers-extracted
    package-version-server
  ];

  # docker
  virtualisation.docker = {
    enable = true;
  };
}

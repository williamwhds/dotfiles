{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    # text editors
    pkgs-unstable.zed-editor
    neovim

    # nix
    nil
    nixd

    # web / general
    nodePackages.vscode-langservers-extracted
    package-version-server
  ];
}

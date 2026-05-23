{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = with pkgs; [
    pkgs-unstable.zed-editor
    neovim

    # Nix
    nil
    nixd

    # Web / general
    nodePackages.vscode-langservers-extracted
    package-version-server
  ];
}

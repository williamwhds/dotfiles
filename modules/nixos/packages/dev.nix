{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zed-editor
    neovim

    # Nix
    nil
    nixd

    # Web / general
    nodePackages.vscode-langservers-extracted
    package-version-server
  ];
}

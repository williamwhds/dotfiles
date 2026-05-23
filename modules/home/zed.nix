{ pkgs-unstable, ... }:
{
  programs.zed-editor = {
    enable = true;
    package = pkgs-unstable.zed-editor;
    installRemoteServer = true;
    extensions = [ "nix" ];
  };
}

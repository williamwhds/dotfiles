{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obsidian
    bitwarden-desktop
  ];
}

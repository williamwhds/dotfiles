{ pkgs, ... }:

{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    gh # github cli
    curl
    wget
    fastfetch
    btop
  ];
}

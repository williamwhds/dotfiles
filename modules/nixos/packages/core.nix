{ pkgs, ... }:

{
  programs.zsh.enable = true;

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    git
    gh # github cli
    curl
    wget
    fastfetch
    btop
  ];
}

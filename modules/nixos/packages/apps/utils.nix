{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obsidian # notes
    bitwarden-desktop # password manager
    gnome-calculator # me have gnomes and need to count them
    baobab # disk usage analyzer
  ];

  programs.gnome-disks.enable = true; # disk management
}

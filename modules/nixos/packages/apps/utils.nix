{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obsidian # notes
    bitwarden-desktop # password manager
    gnome-calculator # me have gnomes and need to count them
    baobab # disk usage analyzer
    localsend # file sharing
    qbittorrent # torrent client
  ];

  programs.gnome-disks.enable = true; # disk management

  # localsend ports
  networking.firewall.allowedTCPPorts = [ 53317 ];
  networking.firewall.allowedUDPPorts = [ 53317 ];

  services.flatpak.packages = [
    "com.github.tchx84.Flatseal" # flatpak permissions manager
  ];
}

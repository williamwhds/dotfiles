{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos."packages-utils" = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos."packages-utils" = { pkgs, ... }: {
    # bitwarden-desktop requires this end-of-life electron package
    nixpkgs.config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];

    environment.systemPackages = with pkgs; [
      obsidian # notes
      bitwarden-desktop # password manager
      gnome-calculator # me have gnomes and need to count them
      baobab # disk usage analyzer
      localsend # file sharing
      qbittorrent # torrent client
      moonlight-qt # sunshine client
    ];

    programs.gnome-disks.enable = true; # disk management

    # localsend ports
    networking.firewall.allowedTCPPorts = [ 53317 ];
    networking.firewall.allowedUDPPorts = [ 53317 ];

    services.flatpak.packages = [
      "com.github.tchx84.Flatseal" # flatpak permissions manager
    ];
  };
}

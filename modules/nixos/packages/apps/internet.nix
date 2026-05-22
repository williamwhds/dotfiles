{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    floorp-bin
    vesktop
    protonvpn-gui
    wireguard-tools
  ];
}

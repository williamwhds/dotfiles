{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    protonvpn-gui
    wireguard-tools
    tor-browser
    mullvad-browser

    floorp-bin

    vesktop
  ];
}

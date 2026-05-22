{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    protonvpn-gui   # vpn
    wireguard-tools # needed for protonvpn
    tor-browser     # tor browser
    mullvad-browser # privacy focused browser
    vesktop         # discord client
  ];

  services.flatpak.packages = [
    "app.zen_browser.zen" # main browser
  ];
}

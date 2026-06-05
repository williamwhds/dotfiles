{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    proton-vpn # vpn
    wireguard-tools # needed for protonvpn
    tor-browser # tor browser
    mullvad-browser # privacy focused browser
    vesktop # discord client
  ];

  services.flatpak.packages = [
    "app.zen_browser.zen" # main browser
  ];
}

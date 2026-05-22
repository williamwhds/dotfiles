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

  services.flatpak.packages = [
    "app.zen_browser.zen"
  ];
}

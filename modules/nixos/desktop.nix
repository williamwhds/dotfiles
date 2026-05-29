{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  programs.xwayland.enable = true;

  services.printing.enable = true;

  xdg.portal = {
    enable = true;

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    config = {
      common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };

  services.flatpak.enable = true;
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };
}

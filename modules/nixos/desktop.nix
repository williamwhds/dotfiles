{ ... }:

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

  services.flatpak.enable = true;
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };
}

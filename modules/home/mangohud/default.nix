{ ... }:

{
  programs.mangohud.enable = true;
  xdg.configFile."MangoHud/MangoHud.conf".source = ./mangohud.conf;
}

{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  hardware.openrazer = {
    enable = true;
    users = [ "williamwhds" ];
  };

  environment.systemPackages = with pkgs; [
    polychromatic
  ];
}

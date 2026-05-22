{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kdePackages.kdenlive
    obs-studio
  ];
}

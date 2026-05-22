{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    floorp-bin
    vesktop
  ];
}

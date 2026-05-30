{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ inputs.eden.overlays.default ];

  programs.eden.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  hardware.openrazer = {
    enable = true;
    users = [ "williamwhds" ];
  };

  environment.systemPackages = with pkgs; [
    polychromatic
  ];
}

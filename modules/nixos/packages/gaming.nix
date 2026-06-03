{ pkgs, pkgs-unstable, ... }:

let
  eden-emu = pkgs-unstable.eden.overrideAttrs (oldAttrs: {
    version = "0.2.1";
    src = pkgs-unstable.fetchFromGitea {
      domain = "git.eden-emu.dev";
      owner = "eden-emu";
      repo = "eden";
      tag = "v0.2.1";
      hash = "sha256-79/JmIRWysoc3psJqMFyiNc2gjTY4VhJfdNaiTvisMk=";
    };
    patches = [ ];
  });
in
{
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
    eden-emu
  ];
}

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

  ryujinx-latest = pkgs.appimageTools.wrapType2 rec {
    pname = "ryujinx";
    version = "1.3.308";

    src = pkgs.fetchurl {
      url = "https://git.ryujinx.app/Ryubing/Canary/releases/download/${version}/ryujinx-canary-${version}-x64.AppImage";
      hash = "sha256:1b8rnrsb2l395jf3qjx95k7j2c593wniizna1wwfrkai2j17nvki";
    };

    extraPkgs =
      pkgs: with pkgs; [
        icu
        lttng-ust
      ];
  };
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
    ryujinx-latest
  ];
}

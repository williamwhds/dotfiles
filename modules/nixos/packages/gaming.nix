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
      # change version and hash manually when new release is out
      # run `nix hash path --type sha256 <path-to-appimage>` to get the new hash
      hash = "sha256:1b8rnrsb2l395jf3qjx95k7j2c593wniizna1wwfrkai2j17nvki";
    };

    extraPkgs =
      pkgs: with pkgs; [
        icu
        lttng-ust
      ];
  };

  ryujinx-extracted = pkgs.appimageTools.extract {
    inherit (ryujinx-latest) pname version src;
  };

  ryujinx-desktop = pkgs.makeDesktopItem {
    name = "ryujinx";
    desktopName = "Ryujinx Canary";
    exec = "${ryujinx-latest}/bin/ryujinx %U";
    icon = "${ryujinx-extracted}/app.ryujinx.Ryujinx.png";
    comment = "Switch Emulator";
    categories = [
      "Game"
      "Emulator"
    ];
    terminal = false;
  };

  ryujinx-with-desktop = pkgs.stdenv.mkDerivation {
    pname = "ryujinx-with-desktop";
    inherit (ryujinx-latest) version;

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${ryujinx-latest}/bin/ryujinx $out/bin/ryujinx

      mkdir -p $out/share/applications
      cp ${ryujinx-desktop}/share/applications/* $out/share/applications/

      mkdir -p $out/share/icons/hicolor/256x256/apps
      ln -s ${ryujinx-extracted}/app.ryujinx.Ryujinx.png $out/share/icons/hicolor/256x256/apps/ryujinx.png
    '';
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
    ryujinx-with-desktop
  ];
}

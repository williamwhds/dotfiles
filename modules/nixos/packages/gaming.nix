{ pkgs, ... }:

let
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

  ryujinx-desktop-bundle = pkgs.stdenv.mkDerivation {
    pname = "ryujinx-desktop";
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

  eden-src = pkgs.fetchurl {
    name = "eden-0.2.1.AppImage";
    url = "https://stable.eden-emu.dev/v0.2.1/Eden-Linux-v0.2.1-amd64-clang-pgo.AppImage";
    # change version and hash manually when new release is out
    # run `nix hash path --type sha256 <path-to-appimage>` to get the new hash
    hash = "sha256:0vds4n5prsp02fc1j21q80dkfcdbj2mdnavji4cq6j06ifcbya3s";
  };

  # uses DwarFS (not squashfs), so extract with dwarfsextract instead of appimageTools.extract
  eden-extracted = pkgs.stdenv.mkDerivation {
    pname = "eden-extracted";
    version = "0.2.1";

    src = eden-src;

    nativeBuildInputs = [ pkgs.dwarfs ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out
      dwarfsextract -i $src -o $out --image-offset auto
    '';
  };

  eden = pkgs.appimageTools.wrapAppImage {
    pname = "eden";
    version = "0.2.1";
    src = eden-extracted;
  };

  eden-desktop = pkgs.makeDesktopItem {
    name = "eden";
    desktopName = "Eden";
    exec = "${eden}/bin/eden %U";
    icon = "${eden-extracted}/dev.eden_emu.eden.svg";
    comment = "Nintendo Switch Emulator";
    categories = [
      "Game"
      "Emulator"
    ];
    terminal = false;
  };

  eden-desktop-bundle = pkgs.stdenv.mkDerivation {
    pname = "eden-desktop";
    version = "0.2.1";

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      ln -s ${eden}/bin/eden $out/bin/eden

      mkdir -p $out/share/applications
      cp ${eden-desktop}/share/applications/* $out/share/applications/

      mkdir -p $out/share/icons/hicolor/scalable/apps
      ln -s ${eden-extracted}/dev.eden_emu.eden.svg $out/share/icons/hicolor/scalable/apps/dev.eden_emu.eden.svg
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
    eden-desktop-bundle
    ryujinx-desktop-bundle
  ];
}

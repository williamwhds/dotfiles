{ ... }:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
  ];

  nix.settings.auto-optimise-store = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 5 --keep-since 3d";
    flake = "/home/williamwhds/.dotfiles";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}

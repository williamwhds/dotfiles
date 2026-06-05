{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    inputs.disko.nixosModules.disko

    # Core system
    ../../modules/nixos/boot.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/locale.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/snapshots.nix

    # Desktop environment
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/niri.nix

    # Packages
    ../../modules/nixos/packages/core.nix
    ../../modules/nixos/packages/dev.nix
    ../../modules/nixos/packages/gaming.nix
    ../../modules/nixos/packages/apps/terminals.nix
    ../../modules/nixos/packages/apps/internet.nix
    ../../modules/nixos/packages/apps/utils.nix
    ../../modules/nixos/packages/apps/media.nix
    ../../modules/nixos/packages/apps/wm-tools.nix
    ../../modules/nixos/packages/apps/office.nix

    # T495-specific
    ../../modules/nixos/optional/battery.nix
    ../../modules/nixos/optional/fingerprint.nix
  ];

  # this host uses btrfs, so we need to use it for docker too
  virtualisation.docker.storageDriver = "btrfs";

  # symlinking dotfiles to /etc/nixos
  systemd.tmpfiles.rules = [
    "L+ /etc/nixos - - - - /home/williamwhds/.dotfiles"
  ];

  networking.hostName = "t495";
  system.stateVersion = "25.11";
}

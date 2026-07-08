{
  config,
  lib,
  inputs,
  pkgs-unstable,
  system,
  ...
}:
let
  inherit (lib) types;

  nixosModuleNames = [
    "audio"
    "boot"
    "desktop"
    "fonts"
    "hardware"
    "locale"
    "networking"
    "niri"
    "nix"
    "snapshots"
    "users"
    "packages-core"
    "packages-dev"
    "packages-gaming"
    "packages-internet"
    "packages-media"
    "packages-office"
    "packages-terminals"
    "packages-utils"
    "battery"
    "fingerprint"
    "sops"
  ];

  homeModuleNames = [
    "shell"
    "quickshell"
    "niri"
    "noctalia"
    "plasma"
    "zed"
    "mangohud"
  ];

  resolvedNixosModules = map (name: config.myModules.nixos.${name}) nixosModuleNames;
  resolvedHomeModules = map (name: config.myModules.home.${name}) homeModuleNames;

  homeImports = resolvedHomeModules ++ [
    inputs.plasma-manager.homeModules.plasma-manager
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default

    {
      home.username = "williamwhds";
      home.homeDirectory = "/home/williamwhds";
      home.stateVersion = "26.05";
      programs.home-manager.enable = true;
    }
  ];

in
{
  options.myModules.hosts.t495 = lib.mkOption {
    type = types.submodule {
      options = {
        nixosModules = lib.mkOption {
          type = types.listOf types.raw;
          description = "NixOS modules applied to t495.";
        };
        homeModules = lib.mkOption {
          type = types.listOf types.raw;
          description = "Home-manager modules applied to t495.";
        };
      };
    };
  };

  config.myModules.hosts.t495 = {
    nixosModules = resolvedNixosModules;
    homeModules = resolvedHomeModules;
  };

  config.flake.nixosConfigurations.t495 = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs pkgs-unstable;
    };
    modules =
      # dendritic feature modules
      resolvedNixosModules
      # flake input nixos modules
      ++ [
        inputs.home-manager.nixosModules.home-manager
        inputs.nix-flatpak.nixosModules.nix-flatpak
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
      ]
      # host-specific hardware & disk config
      ++ [
        ../../hosts/t495/disko-config.nix
        ../../hosts/t495/hardware-configuration.nix
      ]
      # host-level config & home-manager wiring
      ++ [
        {
          networking.hostName = "t495";
          system.stateVersion = "26.05";

          # this host uses btrfs, so we need to use it for docker too
          virtualisation.docker.storageDriver = "btrfs";

          # symlinking dotfiles to /etc/nixos
          systemd.tmpfiles.rules = [
            "L+ /etc/nixos - - - - /home/williamwhds/.dotfiles"
          ];

          # home-manager integration
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs pkgs-unstable;
            };
            users.williamwhds =
              {
                config,
                lib,
                pkgs,
                ...
              }:
              {
                imports = homeImports;

                home.file =
                  builtins.mapAttrs
                    (key: value: {
                      source = config.lib.file.mkOutOfStoreSymlink "/home/williamwhds/.dotfiles/${value}";
                    })
                    {
                      ".config/nvim" = "home/config/nvim";
                    };

                home.activation.cloneDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                  if [ ! -d "$HOME/.dotfiles" ]; then
                    ${pkgs.git}/bin/git clone \
                      https://github.com/williamwhds/dotfiles "$HOME/.dotfiles"
                  fi
                '';
              };
          };
        }
      ];
  };
}

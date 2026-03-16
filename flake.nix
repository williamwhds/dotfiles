{
  description = "My NixOS config";

  inputs = {
    # packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # home-manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # secrets management
    sops-nix.url = "github:Mic92/sops-nix";

    dotfiles-private = {
      url = "github:williamwhds/dotfiles-private";
      flake = false; # just some private folders and files
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, dotfiles-private, ... }@inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      nixos-z550ma = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit dotfiles-private; }; # apparently I need this to use the private files in the configuration
        modules = [
          ./configuration.nix # my config files
          sops-nix.nixosModules.sops # sops for secrets management
          home-manager.nixosModules.home-manager # home-manager for dotfiles
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit dotfiles-private; }; # apparently I need to do it twice
            home-manager.users.williamwhds = ./home.nix;
          }
        ];
      };
    };
  };
}

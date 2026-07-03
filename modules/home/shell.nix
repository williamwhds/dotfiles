{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.home.shell = lib.mkOption { type = types.deferredModule; };

  config.myModules.home.shell = {
    programs.zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      oh-my-zsh.theme = "gnzh";
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        sops-edit = "cd ~/.dotfiles && SOPS_AGE_KEY_FILE=/var/lib/sops-nix/keys.txt nix run nixpkgs#sops -- secrets/secrets.yaml";
      };
    };
  };
}

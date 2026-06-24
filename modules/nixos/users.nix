{ config, pkgs, ... }:

{
  users.users.williamwhds = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."williamwhds-password".path;
    shell = pkgs.zsh;
    description = "William Oliveira";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };
}

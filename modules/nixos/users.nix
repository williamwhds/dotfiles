{ pkgs, ... }:

{
  users.users.williamwhds = {
    isNormalUser = true;
    password = null;
    shell = pkgs.zsh;
    description = "William Oliveira";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}

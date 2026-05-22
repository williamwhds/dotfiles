{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

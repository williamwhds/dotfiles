{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.fingerprint = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.fingerprint = {
    services.fprintd.enable = true;

    security.pam.services.sudo.fprintAuth = true;
    security.pam.services.login.fprintAuth = false;
    security.pam.services.login.enableKwallet = true;
  };
}

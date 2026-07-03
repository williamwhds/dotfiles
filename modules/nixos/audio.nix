{ lib, ... }:
let
  inherit (lib) types;
in
{
  options.myModules.nixos.audio = lib.mkOption { type = types.deferredModule; };

  config.myModules.nixos.audio = {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}

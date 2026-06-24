{ config, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # Master age key
    age.keyFile = "/var/lib/sops-nix/keys.txt";

    secrets = {
      # The password needs to be available early in the boot process
      "williamwhds-password" = {
        neededForUsers = true;
      };

      "ds-hermes-key" = { };
    };
  };
}

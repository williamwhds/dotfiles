{ config, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # Use the host's SSH key for decryption
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Optional: sops-nix will automatically use this path for a generated key if needed
    age.keyFile = "/var/lib/sops-nix/key.txt";
    age.generateKey = true;

    secrets = {
      # The password needs to be available early in the boot process
      "williamwhds-password" = {
        neededForUsers = true;
      };

      "ds-hermes-key" = { };
    };
  };
}

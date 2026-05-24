{ ... }:

{
  networking.networkmanager.enable = true;

  services.zerotierone = {
    enable = true;
    port = 9993;
  };

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [
    22 # ssh
  ];
}

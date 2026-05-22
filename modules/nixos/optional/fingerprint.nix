{ ... }:

{
  services.fprintd.enable = true;

  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.login.fprintAuth = false;
  security.pam.services.login.enableKwallet = true;
}

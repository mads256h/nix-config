{ ... }:
{
  services.fail2ban = {
    enable = true;
    jails = {
      sshd.settings.enabled = true;
      nginx-bad-request.settings.enabled = true;
      nginx-botsearch.settings.enabled = true;
      nginx-forbidden.settings.enabled = true;
      nginx-http-auth.settings.enabled = true;
    };
  };
}

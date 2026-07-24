# vim: ts=2 sw=2 et
{
  services.fail2ban = {
    enable = true;
    jails = {
      sshd.settings.enabled = true;
      nginx-http-auth.settings.enabled = true;
      nginx-botsearch.settings.enabled = true;
    };
  };
}

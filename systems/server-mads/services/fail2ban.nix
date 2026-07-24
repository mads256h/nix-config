# vim: ts=2 sw=2 et
{
  services.fail2ban = {
    enable = true;
    jails = {
      sshd.settings.enabled = true;
      nginx-http-auth.settings = {
        enabled = true;
        filter = "nginx-http-auth";
        port = "http,https";
        backend = "auto";
        logpath = "/var/log/nginx/error.log";
      };
      nginx-botsearch.settings = {
        enabled = true;
        filter = "nginx-botsearch";
        port = "http,https";
        backend = "auto";
        logpath = "/var/log/nginx/access.log";
      };
    };
  };
}

{ ... }:
{
  services.fail2ban = {
    enable = true;
    jails = {
      sshd.settings = {
        enabled = true;
        mode = "aggressive";
      };
      nginx-bad-request.settings.enabled = true;
      nginx-botsearch.settings.enabled = true;
      nginx-forbidden.settings.enabled = true;
      nginx-http-auth.settings.enabled = true;
      nginx-nosuchfile = {
        filter = {
          Definition.failregex = [
            "^.*(?:open\\(\\) \".*\" failed|\".*\" is not found) \\(2: No such file or directory\\), client: <HOST>, .*$"
          ];
        };
        settings = {
          enabled = true;
          journalmatch = "_SYSTEMD_UNIT=nginx.service";
        };
      };
    };
  };
}

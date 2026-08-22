{ ... }:
{
  services.fail2ban = {
    enable = true;
    ignoreIP = [ "10.0.1.0/24" ];
    bantime = "1h";
    bantime-increment.enable = true;
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
          INCLUDES.before = "nginx-error-common.conf";
          Definition = {
            failregex = "^%(__prefix_line)s(?:open\\(\\) \".*\" failed|\".*\" is not found) \\(2: No such file or directory\\), client: <HOST>";
            ignoreregex = "";
            datepattern = "{^LN-BEG}";
            journalmatch = "_SYSTEMD_UNIT=nginx.service + _COMM=nginx";
          };
        };
        settings = {
          enabled = true;
        };
      };
    };
  };
}

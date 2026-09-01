{
  config,
  ...
}:
{
  age.secrets = {
    htpasswd-webdav = {
      file = ../../../../secrets/htpasswd.age;
      owner = "root";
      group = "webdav";
      mode = "440";
    };
  };

  services.webdav-server-rs = {
    enable = true;
    debug = true;
    settings = {
      server.listen = [
        "127.0.0.1:4918"
        "[::1]:4918"
      ];
      accounts = {
        auth-type = "htpasswd.default";
        acct-type = "unix";
      };

      htpasswd.default = {
        htpasswd = config.age.secrets.htpasswd-webdav.path;
      };
      location = [
        {
          route = [ "/*path" ];
          directory = "/mnt/share";
          handler = "filesystem";
          methods = [ "webdav-rw" ];
          autoindex = true;
          auth = "true";
          setuid = true;
        }
      ];
    };
  };

  services.nginx.virtualHosts."webdav.madsmogensen.dk".locations."/" = {
    basicAuthFile = config.age.secrets.htpasswd-nginx.path;
    proxyPass = "http://localhost:4918/";
    extraConfig = ''
      proxy_set_header  X-Script-Name /;
      proxy_pass_header Authorization;
    '';
  };
}

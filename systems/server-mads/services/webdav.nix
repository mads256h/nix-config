# vim: ts=2 sw=2 et
{ config, lib, pkgs, ... }:

{
  services.webdav-server-rs = {
    enable = true;
    debug = true;
    settings = {
      server.listen = [ "127.0.0.1:4918" ];
      accounts = {
        auth-type = "htpasswd.default";
	acct-type = "unix";
      };

      htpasswd.default = {
        htpasswd = "/mnt/data/webdav/htpasswd";
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
    basicAuthFile = "/mnt/data/grafana/htpasswd";
    proxyPass = "http://localhost:4918/";
    extraConfig =
      "proxy_set_header  X-Script-Name /;" +
      "proxy_pass_header Authorization;"
      ;
  };
}

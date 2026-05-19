# vim: ts=2 sw=2 et
{ config, lib, pkgs, ... }:

let port = 5232;
in {
  services.radicale = {
    enable = true;
    settings = {
      server = {
        hosts = [ "127.0.0.1:${toString port}" ];
        ssl = false;
      };
      auth = {
        type = "htpasswd";
        htpasswd_filename = "/mnt/data/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
      storage.filesystem_folder = "/mnt/data/radicale/collections";
      web.type = "none";
    };
  };

  services.nginx = {
    virtualHosts."home.madsmogensen.dk" =  {
      locations."/radicale/" = {
        proxyPass = "http://localhost:${toString port}/";
        extraConfig =
          "proxy_set_header  X-Script-Name /radicale;" +
          "proxy_pass_header Authorization;"
          ;
      };
    };

    virtualHosts."server-mads.lan" =  {
      locations."/radicale/" = {
        proxyPass = "http://localhost:${toString port}/";
        extraConfig =
          "proxy_set_header  X-Script-Name /radicale;" +
          "proxy_pass_header Authorization;"
          ;
      };
    };
  };
}

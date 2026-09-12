{ config, lib, ... }:
let
  makeProxy =
    name: port:
    let
      location = {
        basicAuthFile = config.age.secrets.htpasswd-nginx.path;
        proxyPass = "http://localhost:${toString port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_redirect off;
        '';
      };
    in
    {
      virtualHosts."home.madsmogensen.dk".locations."/arr/${name}" = location;
      virtualHosts."server-mads.lan".locations."/arr/${name}" = location;
    };
in
{
  services.prowlarr = {
    enable = true;
    settings.server.urlbase = "/arr/prowlarr";
  };

  services.sonarr = {
    enable = true;
    settings.server.urlbase = "/arr/sonarr";
    user = "transmission";
    group = "transmission";
  };

  services.radarr = {
    enable = true;
    settings.server.urlbase = "/arr/radarr";
    user = "transmission";
    group = "transmission";
  };

  services.flaresolverr.enable = true;

  services.nginx = lib.mkMerge [
    (makeProxy "prowlarr" config.services.prowlarr.settings.server.port)
    (makeProxy "sonarr" config.services.sonarr.settings.server.port)
    (makeProxy "radarr" config.services.radarr.settings.server.port)
  ];
}

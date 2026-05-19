# vim: ts=2 sw=2 et
{ config, lib, pkgs, ... }:

let domain = "spotify.madsmogensen.dk";
in {

  services.your_spotify = {
    enable = true;
    settings = {
      PORT = 8081;
      SPOTIFY_PUBLIC = "fc73d99e5b3444cba1a06c846ef17067";
      CLIENT_ENDPOINT = "https://${domain}";
      API_ENDPOINT = "https://${domain}/api";
    };
    spotifySecretFile = "/mnt/data/your_spotify/secret";
    enableLocalDB = true;
    nginxVirtualHost = domain;
  };

  services.nginx = {
    virtualHosts."spotify.madsmogensen.dk" = {
      basicAuthFile = "/mnt/data/your_spotify/htpasswd";

      locations."/api/" = {
        proxyPass = "http://localhost:${toString config.services.your_spotify.settings.PORT}/";
        extraConfig =
          "proxy_set_header  X-Script-Name /api;" +
          "proxy_pass_header Authorization;"
          ;
      };
    };
  };
}

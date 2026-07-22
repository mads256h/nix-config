# vim: ts=2 sw=2 et
{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openPeerPorts = true;
    settings = {
      download-dir = "/mnt/share/torrents/complete";

      rpc-bind-address = "127.0.0.1";
      rpc-whitelist = "127.0.0.1,::1";
      rpc-whitelist-enabled = true;
      rpc-host-whitelist = "home.madsmogensen.dk";
      rpc-host-whitelist-enabled = true;
    };
  };

  services.nginx.virtualHosts."home.madsmogensen.dk" = {
    locations."/transmission/" = {
      basicAuthFile = "/mnt/data/grafana/htpasswd";
      proxyPass = "http://127.0.0.1:${toString config.services.transmission.settings.rpc-port}";
      extraConfig = "proxy_pass_header X-Transmission-Session-Id;";
    };
  };
}

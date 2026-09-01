{
  config,
  pkgs,
  ...
}:

{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openPeerPorts = true;
    settings = {
      download-dir = "/mnt/torrents";

      rpc-bind-address = "127.0.0.1";
      rpc-whitelist = "127.0.0.1,::1";
      rpc-whitelist-enabled = true;
      rpc-host-whitelist = "home.madsmogensen.dk";
      rpc-host-whitelist-enabled = true;
    };
  };

  # Transmission should be of least concern. Prioritize streaming.
  systemd.services.transmission.serviceConfig.IOSchedulingClass = "idle";

  services.nginx.virtualHosts."home.madsmogensen.dk" = {
    locations."/transmission/" = {
      basicAuthFile = config.age.secrets.htpasswd-nginx.path;
      proxyPass = "http://127.0.0.1:${toString config.services.transmission.settings.rpc-port}";
      extraConfig = "proxy_pass_header X-Transmission-Session-Id;";
    };
  };
}

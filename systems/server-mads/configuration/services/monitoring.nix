{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 8082;
        http_addr = "127.0.0.1";
        domain = "home.madsmogensen.dk";
        root_url = "https://home.madsmogensen.dk/grafana/";
        serve_from_sub_path = true;
      };
      security.secret_key = "SW2YcwTIb9zpOOhoPsMm"; # TODO: Replace this default key from nixos
    };
  };

  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
    locations."/grafana/" = {
      basicAuthFile = config.age.secrets.htpasswd-nginx.path;
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };

  services.prometheus = {
    enable = true;
    port = 9001;

    exporters.node = {
      enable = true;
      enabledCollectors = [ "systemd" ];
      port = 9002;
    };

    exporters.nginx = {
      enable = true;
      port = 9003;
    };

    exporters.smartctl = {
      enable = true;
      port = 9004;
    };

    exporters.fail2ban = {
      enable = true;
      port = 9005;
    };

    exporters.zfs = {
      enable = true;
      port = 9006;
    };

    exporters."exportarr-sonarr" = {
      enable = true;
      port = 9007;
      url = "http://127.0.0.1:${toString config.services.sonarr.settings.server.port}${config.services.sonarr.settings.server.urlbase}";
      environment.API_KEY = config.services.sonarr.settings.auth.apikey;
    };

    exporters."exportarr-radarr" = {
      enable = true;
      port = 9008;
      url = "http://127.0.0.1:${toString config.services.radarr.settings.server.port}${config.services.radarr.settings.server.urlbase}";
      environment.API_KEY = config.services.radarr.settings.auth.apikey;
    };

    exporters."exportarr-prowlarr" = {
      enable = true;
      port = 9009;
      url = "http://127.0.0.1:${toString config.services.prowlarr.settings.server.port}${config.services.prowlarr.settings.server.urlbase}";
      environment.API_KEY = config.services.prowlarr.settings.auth.apikey;
    };

    scrapeConfigs = [
      {
        job_name = "server";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.nginx.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.smartctl.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.fail2ban.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters.zfs.port}"
              "127.0.0.1:${toString config.services.prometheus.exporters."exportarr-sonarr".port}"
              "127.0.0.1:${toString config.services.prometheus.exporters."exportarr-radarr".port}"
              "127.0.0.1:${toString config.services.prometheus.exporters."exportarr-prowlarr".port}"
            ];
          }
        ];
      }
    ];
  };

  services.nginx.virtualHosts."localhost" = {
    locations."/nginx_status" = {
      extraConfig = "stub_status;";
    };
  };

  # Fix for fail2ban exporter
  systemd.services."prometheus-fail2ban-exporter".serviceConfig.ExecStart = lib.mkForce ''
    ${lib.getExe pkgs.prometheus-fail2ban-exporter} \
      ${lib.optionalString config.services.prometheus.exporters.fail2ban.exitOnError ''--collector.f2b.exit-on-socket-connection-error \''}
      --web.listen-address="${config.services.prometheus.exporters.fail2ban.host}:${toString config.services.prometheus.exporters.fail2ban.port}" \
      --collector.f2b.socket=${config.services.prometheus.exporters.fail2ban.fail2banSocket}
  '';

}

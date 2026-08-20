# vim: ts=2 sw=2 et
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
      basicAuthFile = "/mnt/data/grafana/htpasswd";
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

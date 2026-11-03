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
    };

    exporters."exportarr-radarr" = {
      enable = true;
      port = 9008;
      url = "http://127.0.0.1:${toString config.services.radarr.settings.server.port}${config.services.radarr.settings.server.urlbase}";
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

  systemd.services."prometheus-exportarr-sonarr-exporter" = {
    wants = [ "sonarr.service" ];
    after = [ "sonarr.service" ];
    serviceConfig = {
      User = lib.mkForce "transmission";
      Group = lib.mkForce "transmission";
      ExecStart = lib.mkForce ''
        ${pkgs.bash}/bin/bash -euc '
          api_key="$(${pkgs.gnused}/bin/sed -n "s:.*<ApiKey>\\(.*\\)</ApiKey>.*:\\1:p" /var/lib/sonarr/.config/NzbDrone/config.xml | ${pkgs.coreutils}/bin/head -n 1)"
          export API_KEY="$api_key"
          exec ${lib.getExe config.services.prometheus.exporters."exportarr-sonarr".package} sonarr
        '
      '';
    };
  };

  systemd.services."prometheus-exportarr-radarr-exporter" = {
    wants = [ "radarr.service" ];
    after = [ "radarr.service" ];
    serviceConfig = {
      User = lib.mkForce "transmission";
      Group = lib.mkForce "transmission";
      ExecStart = lib.mkForce ''
        ${pkgs.bash}/bin/bash -euc '
          api_key="$(${pkgs.gnused}/bin/sed -n "s:.*<ApiKey>\\(.*\\)</ApiKey>.*:\\1:p" /var/lib/radarr/.config/Radarr/config.xml | ${pkgs.coreutils}/bin/head -n 1)"
          export API_KEY="$api_key"
          exec ${lib.getExe config.services.prometheus.exporters."exportarr-radarr".package} radarr
        '
      '';
    };
  };
}

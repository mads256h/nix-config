{
  config,
  pkgs,
  lib,
  ...
}:
let
  settingsDir = ".config/transmission-daemon";
  cfg = config.services.transmission;
  optionalString = lib.optionalString;
in
{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openPeerPorts = true;
    settings = {
      download-dir = "/mnt/torrents";
      incomplete-dir-enabled = false;

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

  # Fix for locking issue on transmission
  security.apparmor.includes."local/bin.transmission-daemon" = lib.mkForce ''
    ${config.systemd.services.transmission.environment.CURL_CA_BUNDLE} r,

    owner ${cfg.home}/${settingsDir}/ rk,
    owner ${cfg.home}/${settingsDir}/** rwk,
    ${cfg.settings.download-dir}/** rw,
    ${optionalString cfg.settings.incomplete-dir-enabled ''
      ${cfg.settings.incomplete-dir}/** rw,
    ''}
    ${optionalString cfg.settings.watch-dir-enabled ''
      ${cfg.settings.watch-dir}/** r${optionalString cfg.settings.trash-original-torrent-files "w"},
    ''}
    profile dirs {
      ${cfg.settings.download-dir}/** rw,
      ${optionalString cfg.settings.incomplete-dir-enabled ''
        ${cfg.settings.incomplete-dir}/** rw,
      ''}
      ${optionalString cfg.settings.watch-dir-enabled ''
        ${cfg.settings.watch-dir}/** r${optionalString cfg.settings.trash-original-torrent-files "w"},
      ''}
    }

    ${optionalString
      (cfg.settings.script-torrent-done-enabled && cfg.settings.script-torrent-done-filename != null)
      ''
        # Stack transmission_directories profile on top of
        # any existing profile for script-torrent-done-filename
        # FIXME: to be tested as I'm not sure it works well with NoNewPrivileges=
        # https://gitlab.com/apparmor/apparmor/-/wikis/AppArmorStacking#seccomp-and-no_new_privs
        ${cfg.settings.script-torrent-done-filename} px -> &@{dirs},
      ''
    }

    ${optionalString (cfg.webHome != null) ''
      ${cfg.webHome}/** r,
    ''}
  '';
}

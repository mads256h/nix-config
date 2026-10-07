{
  lib,
  pkgs,
  ...
}:

let
  sharePath = "/mnt/share/Delte Filer/Spil/ps3";
  whitelistIp = "10.1.1.2";
  port = 38008;
in
{
  networking.firewall.allowedTCPPorts = [ port ];

  systemd.services.ps3netsrv = {
    description = "PS3 Net Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      DynamicUser = true;
      ExecStart = "${lib.getExe pkgs.ps3netsrv} ${lib.escapeShellArg sharePath} ${toString port} ${whitelistIp}";
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      ReadOnlyPaths = [ sharePath ];
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" ];
    };
  };
}

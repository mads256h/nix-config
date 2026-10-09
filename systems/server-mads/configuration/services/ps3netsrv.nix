{
  lib,
  pkgs,
  ...
}:

let
  sharePath = "/mnt/share/Delte Filer/Spil/ps3";
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
      SupplementaryGroups = "users";
      ExecStart = "${lib.getExe pkgs.ps3netsrv-go} server --root=${lib.escapeShellArg sharePath} --strict-root --log-level=debug";
      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      #ReadOnlyPaths = [ (lib.escapeShellArg sharePath) ];
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

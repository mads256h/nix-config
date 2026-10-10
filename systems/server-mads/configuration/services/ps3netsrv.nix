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
      SupplementaryGroups = "users"; # Access to ps3 folder
      ExecStart = "${lib.getExe pkgs.ps3netsrv-go} server --root=${lib.escapeShellArg sharePath} --strict-root";
      CapabilityBoundingSet = [ "" ];
      DeviceAllow = [ "" ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = [
        "AF_INET"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@chown"
        "~@keyring"
        "~@resources"
        "~@setuid"
        "~@privileged"
      ];
      UMask = 0077; # Wont be writing anything anyhow
    };
  };
}

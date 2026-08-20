{ ... }:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    dataDir = "/mnt/data/minecraft-aau";
    openFirewall = true;
  };

  # Harden minecraft server
  systemd.services.minecraft-server.serviceConfig = {
    RemoveIPC = true;
    NoNewPrivileges = true;
    ProtectSystem = "full";
    SystemCallFilter = [
      "@system-service"
      "~@chown"
      "~@keyring"
      "~@resources"
      "~@setuid"
      "~@privileged"
    ];
  };
}

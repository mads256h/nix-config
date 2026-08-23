{ ... }:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    dataDir = "/mnt/data/minecraft-aau";
    openFirewall = true;
    # Decrease the reserved memory from default 2gb to something more reasonable
    jvmOpts = "-Xmx2048M -Xms256M";
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

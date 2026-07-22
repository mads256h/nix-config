{ lib, pkgs, config, ... }:
{
  virtualisation.vmVariant = {
    virtualisation.graphics = false;
    virtualisation.memorySize = 2048;
    virtualisation.cores = 2;

    # Don't try to load a real GPU driver or secure boot in containers CI
    services.xserver.videoDrivers = lib.mkForce [ ];
    boot.lanzaboote.enable = lib.mkForce false;

    services.btrfs.autoScrub.enable = lib.mkForce false;

    # No NIC at all -> no DHCP wait, no interface-naming stall
    virtualisation.qemu.networkingOptions = lib.mkForce [ ];
    systemd.network.wait-online.enable = lib.mkForce false;
    networking.useDHCP = lib.mkForce false;
    networking.interfaces = lib.mkForce { };
    services.minecraft-server.enable = lib.mkForce false;
    services.radicale.enable = lib.mkForce false;
    services.transmission.settings.download-dir = lib.mkForce "${config.services.transmission.home}/Downloads";

    # Auto-shutdown once we've successfully reached multi-user.target
    systemd.services.ci-boot-success = {
      description = "Signal successful boot for CI, then poweroff";
      wantedBy = [ "multi-user.target" ];
      after = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        StandardOutput = "journal+console";
      };
      script = ''
        sleep 15

        FAILED=$(${pkgs.systemd}/bin/systemctl list-units --failed --no-legend --plain | ${pkgs.gawk}/bin/awk '{print $1}')

        if [ -n "$FAILED" ]; then
          echo "CI_UNITS_FAILED"
          for unit in $FAILED; do
            echo "----- journalctl -u $unit -----"
            ${pkgs.systemd}/bin/journalctl -u "$unit" --no-pager -b
            echo "----- end $unit -----"
          done
        else
          echo "CI_UNITS_OK"
        fi

        echo "CI_BOOT_OK"
        ${pkgs.systemd}/bin/systemctl poweroff
      '';
    };
  };
}

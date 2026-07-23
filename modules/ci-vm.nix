{ lib, pkgs, config, sysconfig, ... }:
{
  virtualisation.vmVariant = {
    virtualisation.graphics = false;
    virtualisation.memorySize = 2048;
    virtualisation.cores = 2;
    virtualisation.resolution = lib.optionalAttrs sysconfig.graphical {
      x = 1920;
      y = 1080;
    };
    virtualisation.qemu.options = lib.optional sysconfig.graphical "-vga none -device virtio-gpu-pci";

    # Auto login
    services.getty.autologinUser = lib.mkForce "mads";

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

    systemd.timers = lib.optionalAttrs sysconfig.server {
      "acme-order-renew-file.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-home.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-webdav.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-spotify.madsmogensen.dk".enable = lib.mkForce false;
    };

    systemd.services = lib.optionalAttrs sysconfig.server {
      "acme-order-renew-file.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-home.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-webdav.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-spotify.madsmogensen.dk".enable = lib.mkForce false;
    } // {
      # Auto-shutdown once we've successfully reached multi-user.target
      ci-boot-success = {
        description = "Signal successful boot for CI, then poweroff";
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          StandardOutput = "journal+console";
        };
        script = ''
          sleep 30

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

          ${lib.optionalString sysconfig.graphical ''
          HYPR_LOG=$(find /run/user/*/hypr -maxdepth 2 -name 'hyprland.log' 2>/dev/null)
          if [ -z "$HYPR_LOG" ]; then
            echo "CI_HYPR_NOT_STARTED"
          elif grep -qE '(ERR|CRIT) \]:' "$HYPR_LOG"; then
            echo "CI_HYPR_ERRORS_FOUND"
            echo "----- hyprland.log -----"
            cat "$HYPR_LOG"
            echo "----- end -----"
          else
            echo "CI_HYPR_OK"
            echo "----- hyprland.log -----"
            cat "$HYPR_LOG"
            echo "----- end -----"
          fi
          ''}

          echo "CI_BOOT_OK"
          ${pkgs.systemd}/bin/systemctl poweroff
        '';
      };
    };
  };
}

{
  lib,
  pkgs,
  config,
  sysconfig,
  ...
}:
let
  vmVariantConfig = {
    virtualisation.graphics = sysconfig.graphical;
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
    services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
    boot.lanzaboote.enable = lib.mkForce false;
    boot.initrd.network.ssh.hostKeys = lib.mkForce [ ];
    boot.initrd.network.ssh.ignoreEmptyHostKeys = true;
    boot.zswap.enable = lib.mkForce false;

    services.btrfs.autoScrub.enable = lib.mkForce false;

    # No NIC at all -> no DHCP wait, no interface-naming stall
    virtualisation.qemu.networkingOptions = lib.mkForce [ ];
    systemd.network.wait-online.enable = lib.mkForce false;
    networking.useDHCP = lib.mkForce false;
    networking.interfaces = lib.mkForce { };
    services.minecraft-server.enable = lib.mkForce false;
    services.radicale.enable = lib.mkForce false;
    services.smartd.enable = lib.mkForce false; # There are no smart devices on vms
    services.transmission.settings.download-dir = lib.mkForce "${config.services.transmission.home}/Downloads";
    home-manager.users.mads.services.hyprpaper.enable = lib.mkForce false;
    systemd.timers = lib.optionalAttrs sysconfig.server {
      "acme-order-renew-file.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-home.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-webdav.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-spotify.madsmogensen.dk".enable = lib.mkForce false;
      "acme-renew-file.madsmogensen.dk".enable = lib.mkForce false;
      "acme-renew-home.madsmogensen.dk".enable = lib.mkForce false;
      "acme-renew-webdav.madsmogensen.dk".enable = lib.mkForce false;
      "acme-renew-spotify.madsmogensen.dk".enable = lib.mkForce false;
    };

    security.apparmor.includes = lib.optionalAttrs sysconfig.server {
      "local/bin.transmission-daemon" = lib.mkForce ''
        ${config.systemd.services.transmission.environment.CURL_CA_BUNDLE} r,

        owner ${config.services.transmission.home}/.config/transmission-daemon/** rwk,
        ${config.services.transmission.settings.download-dir}/** rwk,
        ${lib.optionalString config.services.transmission.settings.incomplete-dir-enabled ''
          ${config.services.transmission.settings.incomplete-dir}/** rwk,
        ''}
        ${lib.optionalString config.services.transmission.settings.watch-dir-enabled ''
          ${config.services.transmission.settings.watch-dir}/** r${lib.optionalString config.services.transmission.settings.trash-original-torrent-files "w"}k,
        ''}
        profile dirs {
          ${config.services.transmission.settings.download-dir}/** rwk,
          ${lib.optionalString config.services.transmission.settings.incomplete-dir-enabled ''
            ${config.services.transmission.settings.incomplete-dir}/** rwk,
          ''}
          ${lib.optionalString config.services.transmission.settings.watch-dir-enabled ''
            ${config.services.transmission.settings.watch-dir}/** r${lib.optionalString config.services.transmission.settings.trash-original-torrent-files "w"}k,
          ''}
        }

        ${lib.optionalString (config.services.transmission.settings.script-torrent-done-enabled && config.services.transmission.settings.script-torrent-done-filename != null) ''
          ${config.services.transmission.settings.script-torrent-done-filename} px -> &@{dirs},
        ''}

        ${lib.optionalString (config.services.transmission.webHome != null) ''
          ${config.services.transmission.webHome}/** r,
        ''}
      '';
    };

    systemd.services = lib.optionalAttrs sysconfig.server {
      "acme-order-renew-file.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-home.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-webdav.madsmogensen.dk".enable = lib.mkForce false;
      "acme-order-renew-spotify.madsmogensen.dk".enable = lib.mkForce false;
      transmission.serviceConfig.ExecStartPre = lib.mkBefore [
        "+${pkgs.coreutils}/bin/rm -f /var/lib/transmission/.config/transmission-daemon/daemon.lock /var/lib/transmission/.config/transmission-daemon/transmission-daemon.pid"
      ];
      transmission.serviceConfig.Restart = lib.mkForce "on-failure";
      transmission.serviceConfig.RestartSec = lib.mkForce "3s";
      "ps3netsrv".serviceConfig.ExecStartPre = [
        "+${pkgs.coreutils}/bin/install -d -o root -g users ${(lib.escapeShellArg "/mnt/share/Delte Filer/Spil/ps3")}"
      ];
    };
  };
in
{
  options.ciVm.applyToCurrentSystem = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = lib.mkMerge [
    {
      virtualisation.vmVariant = vmVariantConfig;
    }
    (lib.mkIf config.ciVm.applyToCurrentSystem (
      builtins.removeAttrs vmVariantConfig [ "virtualisation" ]
    ))
  ];
}

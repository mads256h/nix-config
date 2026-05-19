# vim: ts=2 sw=2 et
{ config, lib, pkgs, ... }:

{
  services.minidlna = {
    enable = true;
    settings = {
      media_dir = [ "/mnt/share/torrents/complete" ];
      inotify = "yes";
      network_interface = "enp1s0";
    };
  };

  # Allow through firewall
  networking.firewall.interfaces."enp1s0" = {
    allowedTCPPorts = [ config.services.minidlna.settings.port ];

    # SSDP
    allowedUDPPorts = [ 1900 ];
  };
}

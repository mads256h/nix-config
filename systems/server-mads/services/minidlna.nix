# vim: ts=2 sw=2 et
{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.minidlna = {
    enable = true;
    settings = {
      media_dir = [ "/mnt/share/torrents/complete" ];
      inotify = "yes";
    };
    openFirewall = true;
  };
}

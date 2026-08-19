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
      media_dir = [ "/export/torrents" ]; # Use read only bind mount
      inotify = "yes";
    };
    openFirewall = true;
  };
}

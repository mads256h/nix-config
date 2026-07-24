# vim: ts=2 sw=2 et
{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./fail2ban.nix
    ./minidlna.nix
    ./monitoring.nix
    ./nfs.nix
    ./nginx.nix
    ./radicale.nix
    ./transmission.nix
    ./webdav.nix
    #      ./your_spotify.nix
  ];
}

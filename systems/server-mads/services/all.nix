# vim: ts=2 sw=2 et
{ config, lib, pkgs, ... }:

{
  imports = 
    [
      ./minidlna.nix
      ./monitoring.nix
      ./nfs.nix
      ./nginx.nix
      ./radicale.nix
      ./transmission.nix
      ./webdav.nix
      ./wireguard.nix
#      ./your_spotify.nix
    ];
}

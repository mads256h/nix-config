{ ... }:
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
  ];
}

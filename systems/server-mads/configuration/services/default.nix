{ ... }:
{
  imports = [
    ./fail2ban.nix
    ./minecraft-server.nix
    ./minidlna.nix
    ./monitoring.nix
    ./nfs.nix
    ./nginx.nix
    ./radicale.nix
    ./transmission.nix
    ./update-yt.nix
    ./webdav.nix
  ];
}

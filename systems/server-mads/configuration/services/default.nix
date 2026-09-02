{ ... }:
{
  imports = [
    ./fail2ban.nix
    ./minecraft-server.nix
    ./monitoring.nix
    ./nfs.nix
    ./nginx.nix
    ./radicale.nix
    ./sendmail.nix
    ./transmission.nix
    ./update-yt.nix
    ./webdav.nix
  ];
}

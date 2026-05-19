# vim: ts=2 sw=2 et
{ config, lib, pkgs, ... }:

{
  # Enable WireGuard
  networking.wg-quick.interfaces."wg0" = {
    address = [ "192.168.1.2/24" ];
    privateKeyFile = "/mnt/data/wireguard/private-key";
    listenPort = 43773;
    peers = [
      {
        publicKey = "oI3lz6JjGMk6DltTSYuMWiArdbNCQVaPnoT/HIiXrSY=";
        allowedIPs = [ "192.168.1.1/24" ];
        endpoint = "142.93.101.55:51820";
        persistentKeepalive = 25;
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [config.networking.wg-quick.interfaces."wg0".listenPort];
}

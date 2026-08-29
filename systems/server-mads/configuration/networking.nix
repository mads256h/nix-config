{ ... }:
let
  lanDevName = "enp1s0";

  wireguardDevName = "wg0";
  wireguardAddress = "10.1.1.1/24";
  wireguardPort = 51820;
in
{
  networking.hostName = "server-mads";
  networking.useDHCP = false;
  networking.useNetworkd = true;

  networking.hostId = "8f846d4c";

  systemd.network.enable = true;

  systemd.network.networks."${lanDevName}" = {
    matchConfig.Name = lanDevName;

    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };

    linkConfig.RequiredForOnline = "routable";
  };

  systemd.network.netdevs."50-${wireguardDevName}" = {
    netdevConfig = {
      Kind = "wireguard";
      Name = wireguardDevName;
      MTUBytes = "1300";
    };

    wireguardConfig = {
      PrivateKeyFile = "/mnt/data/secrets/wireguard/server-mads.private";
      ListenPort = wireguardPort;
    };

    wireguardPeers = [
      # android-mads
      {
        PublicKeyFile = "/mnt/data/secrets/wireguard/android-mads.public";
        PresharedKeyFile = "/mnt/data/secrets/wireguard/android-mads.preshared";
        AllowedIPs = [ "10.1.1.2" ];
      }
      # todo: work
      # todo: laptop-mads
    ];
  };

  systemd.network.networks."${wireguardDevName}" = {
    matchConfig.Name = wireguardDevName;
    address = [ wireguardAddress ];
    networkConfig = {
      IPMasquerade = "ipv4";
      IPv4Forwarding = true;
    };
  };

  networking.firewall.allowedUDPPorts = [ wireguardPort ];
}

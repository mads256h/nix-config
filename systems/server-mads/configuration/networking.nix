{ config, ... }:
let
  lanDevName = "enp1s0";

  wireguardDevName = "wg0";
  wireguardAddress = "10.1.1.1/24";
  wireguardPort = 51820;
in
{
  age.secrets = {
    android-mads-wireguard-shared-secret = {
      file = ../../../secrets/android-mads-wireguard-shared-secret.age;
      owner = "root";
      group = "systemd-network";
      mode = "440";
    };

    android-mads-wireguard-public-key = {
      file = ../../../secrets/android-mads-wireguard-public-key.age;
      owner = "root";
      group = "systemd-network";
      mode = "440";
    };

    server-mads-wireguard-private-key = {
      file = ../../../secrets/server-mads-wireguard-private-key.age;
      owner = "root";
      group = "systemd-network";
      mode = "440";
    };
  };

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
    };

    wireguardConfig = {
      PrivateKeyFile = config.age.secrets.server-mads-wireguard-private-key.path;
      ListenPort = wireguardPort;
    };

    wireguardPeers = [
      # android-mads
      {
        PublicKeyFile = config.age.secrets.android-mads-wireguard-public-key.path;
        PresharedKeyFile = config.age.secrets.android-mads-wireguard-shared-secret.path;
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

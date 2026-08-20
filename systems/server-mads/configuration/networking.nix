{ ... }:
{
  networking.hostName = "server-mads";
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  networking.hostId = "8f846d4c";
}

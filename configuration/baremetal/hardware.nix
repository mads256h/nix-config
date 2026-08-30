{ sysconfig, ... }:
{
  hardware.flipperzero.enable = sysconfig.graphical;
  hardware.mcelog.enable = true;
  hardware.steam-hardware.enable = sysconfig.graphical;
}

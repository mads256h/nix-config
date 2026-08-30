{ sysconfig, ... }:
{
  hardware.flipperzero.enable = sysconfig.graphical;
  hardware.steam-hardware.enable = sysconfig.graphical;
}

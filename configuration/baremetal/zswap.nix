{ sysconfig, ... }:
{
  boot.zswap = {
    enable = true;
    maxPoolPercent = if sysconfig.server then 20 else 25;
  };
}

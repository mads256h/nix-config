{ config, ... }:
{
  wsl = {
    enable = true;
    defaultUser = "mads";
    useWindowsDriver = true;
  };
}

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools
    hdparm
    smartmontools
  ];
}

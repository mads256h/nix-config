{ lib, pkgs, ... }:
{
  imports = [
    ../../home/common
    ../../home/graphical
  ];

  home.packages = [
    pkgs.ckan
  ];

  wayland.windowManager.hyprland.settings = {
    config.input = {
      accel_profile = "flat";
      sensitivity = "-0.4";
    };
    monitor.mode = lib.mkForce "highrr";
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}

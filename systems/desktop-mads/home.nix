{ lib, ... }:
{
  imports = [
    ../../home/common
    ../../home/graphical
  ];

  wayland.windowManager.hyprland.settings = {
    config.input = {
      accel_profile = "flat";
      sensitivity = "-0.4";
    };
    config.general.allow_tearing = true;
    monitor.mode = lib.mkForce "highrr";
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  services.wayvnc = {
    enable = true;
    autoStart = true;
    settings = {
      address = "0.0.0.0";
      port = 5901;
    };
  };
}

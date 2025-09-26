{ lib, ... }:
{
  imports = [
    ../../home/common
    ../../home/graphical
  ];

  wayland.windowManager.hyprland.settings = {
    input = {
      accel_profile = "flat";
      sensitivity = "-0.4";
    };
    general.allow_tearing = true;
    monitor = lib.mkForce ", highrr, auto, 1";
    windowrule = "immediate, class:^(cs2)$";
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

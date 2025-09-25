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
}

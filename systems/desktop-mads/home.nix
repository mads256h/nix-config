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
    workspace_rule = [
      {
        workspace = "11";
        monitor = "sunshine";
        persistent = true;
      }
    ];
    window_rule = [
      {
        match.class = "steam";
        workspace = "11";
      }
      {
        match.class = "^steam_app_[0-9]+$";
        workspace = "11";
      }
      {
        match.class = "gamescope";
        workspace = "11";
      }
      {
        match.class = "^steam_app_[0-9]+$";
        fullscreen = true;
      }
      {
        match.class = "gamescope";
        fullscreen = true;
      }
    ];
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}

{
  config,
  pkgs,
  lib,
  inputs,
  sysconfig,
  ...
}:
{
  wayland.windowManager.hyprland = rec {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

    systemd.enable = true;
    systemd.enableXdgAutostart = true;

    xwayland.enable = true;

    plugins = [
      inputs.hy3.packages.x86_64-linux.hy3
      inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprwinwrap
    ];

    settings = {
      "$mod" = "SUPER";
      ecosystem.no_update_news = true;
      general = {
        "border_size" = 0;
        "gaps_in" = 15;
        "gaps_out" = 15;
        "layout" = "hy3";
      };
      decoration = {
        blur = {
          enabled = true;
          size = 4;
          passes = 2;
          xray = true;
          # xray = false;
          # ignore_opacity = false;
          # new_optimizations = false;
        };
        shadow.enabled = false;
      };
      animations.enabled = false;

      bind = [
        "$mod+SHIFT, Q, hy3:killactive"
        "$mod+SHIFT, E, exit"
        "$mod, return, exec, alacritty -e tmux"
        "$mod+SHIFT, return, exec, alacritty"
        "$mod, g, exec, alacritty -e tmux new-session vifmrun"
        "$mod, W, exec, librewolf"
        "$mod, s, exec, spotify"

        "$mod, d, exec, rofi -show drun"

        ''$mod, t, exec, ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.coreutils}/bin/tee ~/Pictures/screenshots/$(date +%s).png | ${pkgs.wl-clipboard}/bin/wl-copy''
        ''$mod+SHIFT, t, exec, ${package}/bin/hyprctl -j activewindow | ${pkgs.jq}/bin/jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | ${pkgs.grim}/bin/grim -g - - | ${pkgs.coreutils}/bin/tee ~/Pictures/screenshots/$(date +%s).png | ${pkgs.wl-clipboard}/bin/wl-copy''
        ''$mod+CTRL, t, exec, ${pkgs.grim}/bin/grim -o "$(${package}/bin/hyprctl -j activeworkspace | ${pkgs.jq}/bin/jq -r .monitor)" - | ${pkgs.coreutils}/bin/tee ~/Pictures/screenshots/$(date +%s).png | ${pkgs.wl-clipboard}/bin/wl-copy''

        "$mod, l, exec, hyprlock"

        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 10%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

        ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl -q set +10%"
        ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl -q set 10%-"

        ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl -p spotify previous"
        ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl -p spotify next"
        ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl -p spotify play-pause"
        "$mod+ALT, left, exec, ${pkgs.playerctl}/bin/playerctl -p spotify previous"
        "$mod+ALT, right, exec, ${pkgs.playerctl}/bin/playerctl -p spotify next"
        "$mod+ALT, up, exec, ${pkgs.playerctl}/bin/playerctl -p spotify play-pause"
        "$mod+ALT, down, exec, ${pkgs.playerctl}/bin/playerctl -p spotify play-pause"

        "$mod+SHIFT, space, togglefloating"
        "$mod, f, fullscreen, 0"

        "$mod, left, hy3:movefocus, l"
        "$mod, right, hy3:movefocus, r"
        "$mod, up, hy3:movefocus, u"
        "$mod, down, hy3:movefocus, d"

        "$mod, h, hy3:makegroup, h, ephemeral"
        "$mod, v, hy3:makegroup, v, ephemeral"

        "$mod, code:10, workspace, 1"
        "$mod, code:11, workspace, 2"
        "$mod, code:12, workspace, 3"
        "$mod, code:13, workspace, 4"
        "$mod, code:14, workspace, 5"
        "$mod, code:15, workspace, 6"
        "$mod, code:16, workspace, 7"
        "$mod, code:17, workspace, 8"
        "$mod, code:18, workspace, 9"
        "$mod, code:19, workspace, 10"

        "$mod+SHIFT, code:10, hy3:movetoworkspace, 1"
        "$mod+SHIFT, code:11, hy3:movetoworkspace, 2"
        "$mod+SHIFT, code:12, hy3:movetoworkspace, 3"
        "$mod+SHIFT, code:13, hy3:movetoworkspace, 4"
        "$mod+SHIFT, code:14, hy3:movetoworkspace, 5"
        "$mod+SHIFT, code:15, hy3:movetoworkspace, 6"
        "$mod+SHIFT, code:16, hy3:movetoworkspace, 7"
        "$mod+SHIFT, code:17, hy3:movetoworkspace, 8"
        "$mod+SHIFT, code:18, hy3:movetoworkspace, 9"
        "$mod+SHIFT, code:19, hy3:movetoworkspace, 10"

        "$mod+CTRL, left, movecurrentworkspacetomonitor, l"
        "$mod+CTRL, right, movecurrentworkspacetomonitor, r"
      ];

      bindm = [ "$mod, mouse:272, movewindow" ];

      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];

      "monitor" = ",preferred,auto,1";
      input = {
        kb_layout = "dk";
        numlock_by_default = true;
      };

      windowrule = [
        "match:class gamescope, immediate yes"
        "match:class cs2, immediate yes"
      ];

      windowrulev2 = [
        "noblur, class:negative:^(Alacritty)$"
        "workspace 2, class:(spotify)"
        "workspace 10, class:(KeePassXC)"
      ];

      plugin = {
        hyprwinwrap = {
          class = "connecting-dots";
        };
      };
    };

    extraConfig = ''
      bind = $mod, R, submap, resize
      submap = resize

      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10

      bind = , escape, submap, reset

      submap = reset
    '';
  };

  stylix.cursor = {
    name = "BreezeX-RosePine-Linux";
    size = 24;
    package = pkgs.buildEnv {
      name = "rose-pine-cursor-merged";
      paths = with pkgs; [
        rose-pine-hyprcursor
        rose-pine-cursor
      ];
    };
  };
  home.sessionVariables.HYPRCURSOR_THEME = lib.mkForce "rose-pine-hyprcursor";
  home.pointerCursor.hyprcursor.enable = true;

  stylix.icons = {
    enable = true;
    light = "rose-pine";
    dark = "rose-pine";
    package = pkgs.rose-pine-icon-theme;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      .modules-left #workspaces {
        padding: 0;
      }

      .modules-left #workspaces button {
        border-bottom-style: none;
        padding: 0;
      }

      .modules-left #workspaces button.active,
      .modules-left #workspaces button.focused {
        border-bottom-style: none;
        box-shadow: none;
      }

      #workspaces button.active {
        background: rgba(171, 178, 191, 0.1);
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        #height = 30;
        spacing = 4;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-right = [
          "mpris"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          #"power-profiles-daemon"
          "cpu"
          "memory"
          "disk"
          "temperature"
          "backlight"
          "sway/language"
          "battery"
          "clock"
          "tray"
          "custom/power"
        ];

        mpris = rec {
          player = "spotify";
          format = "{artist} - {title}";
          format-paused = "<span color=\"#545862\">{artist} - {title}</span>";
          tooltip = false;
          on-click = "${pkgs.playerctl}/bin/playerctl -p ${player} previous";
          on-click-middle = "${pkgs.playerctl}/bin/playerctl -p ${player} play-pause";
          on-click-right = "${pkgs.playerctl}/bin/playerctl -p ${player} next";
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = " ";
            deactivated = " ";
          };
        };
        tray = {
          #icon-size = 21;
          spacing = 10;
        };
        clock = {
          interval = 1;
          format = "{:%Y-%m-%d %H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        disk = {
          format = "{percentage_used}% 󰋊";
        };
        temperature = {
          # thermal-zone = 2;
          # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          # format-critical = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        backlight = {
          # device = "acpi_video1";
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        battery = {
          states = {
            # good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          # format-good = ""; // An empty format will hide the module
          # format-full = "";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };
        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
        network = {
          # interface = "wlp2*"; // (Optional) To force the use of this interface
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          scroll-step = 5;
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        "custom/power" = {
          format = "⏻ ";
          tooltip = false;
          menu = "on-click";
          menu-file = "${pkgs.waybar.src}/resources/custom_modules/power_menu.xml";
          menu-actions = {
            shutdown = "systemctl shutdown";
            reboot = "systemctl reboot";
            suspend = "systemctl suspend";
            hibernate = "systemctl hibernate";
          };
        };
      };
    };
  };

  services.hyprpolkitagent.enable = true;
  programs.hyprlock.enable = true;
  # services.hyprpaper.enable = true;
  # services.hyprpaper.settings.ipc = "on";
  #
  # systemd.user.services.hyprpaper.Service.ExecStartPost =
  #   "${pkgs.writeShellScript "random-wallpaper" ''
  #     #!${pkgs.bash}/bin/bash
  #
  #     WALLPAPER_DIR="$HOME/Pictures/wallpapers/"
  #     CURRENT_WALL=$(${pkgs.hyprland}/bin/hyprctl hyprpaper listloaded)
  #
  #     # Get a random wallpaper that is not the current one
  #     WALLPAPER=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f ! -name "$(${pkgs.coreutils}/bin/basename "$CURRENT_WALL")" | ${pkgs.coreutils}/bin/shuf -n 1)
  #
  #     # Apply the selected wallpaper
  #     ${pkgs.hyprland}/bin/hyprctl hyprpaper reload ,"$WALLPAPER"
  #   ''}";

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ]
      ++ lib.optionals sysconfig.laptop [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

  services.dunst = {
    enable = true;

    settings = {
      global = {
        width = 300;
        height = "(0, 300)";
        origin = "bottom-right";
        offset = "(30, 50)";
        separator_height = 2;
        padding = 8;
        text_icon_padding = 0;
        frame_width = 1;
      };
      urgency_critical = {
        timeout = 0;
      };
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = 1;
}

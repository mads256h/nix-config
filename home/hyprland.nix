{ config, pkgs, lib, inputs, ... }:
let
  randomizeWallpaper = pkgs.writeTextFile {
    name = "random-wallpaper";
    executable = true;
    text = ''
      #!${pkgs.bash}/bin/bash

      WALLPAPER_DIR="$HOME/Pictures/wallpapers/"
      CURRENT_WALL=$(${pkgs.hyprland}/bin/hyprctl hyprpaper listloaded)

      # Get a random wallpaper that is not the current one
      WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

      # Apply the selected wallpaper
      ${pkgs.hyprland}/bin/hyprctl hyprpaper reload ,"$WALLPAPER"
      '';
  };
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    
    systemd.enable = true;
    systemd.enableXdgAutostart = true;

    xwayland.enable = true;
    
    plugins = [
      inputs.hy3.packages.x86_64-linux.hy3
    ];
    
    settings = {
      "$mod" = "SUPER";
      "env" = "HYPRCURSOR_THEME,rose-pine-hyprcursor";
      general = {
        "border_size" = 0;
        "gaps_in" = 15;
        "gaps_out" = 15;
        "layout" = "hy3";
      };
      decoration = {
        blur.enabled = true;
        shadow.enabled = false;
      };
      animations.enabled = false;

      bind = [
        "$mod+SHIFT, Q, hy3:killactive"
        "$mod+SHIFT, E, exit"
        "$mod, return, exec, alacritty -e tmux"
        "$mod, g, exec, alacritty -e vifmrun"
        "$mod, W, exec, librewolf"

        "$mod, d, exec, rofi -show drun"

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
        "$mod+SHIFT, left, exec, ${pkgs.playerctl}/bin/playerctl -p spotify previous"
        "$mod+SHIFT, right, exec, ${pkgs.playerctl}/bin/playerctl -p spotify next"
        "$mod+SHIFT, up, exec, ${pkgs.playerctl}/bin/playerctl -p spotify play-pause"
        "$mod+SHIFT, down, exec, ${pkgs.playerctl}/bin/playerctl -p spotify play-pause"

        "$mod, space, togglefloating"
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
      ];

      workspace = [
        "w[tv1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
      
      "monitor" = ",preferred,auto,1";
      input = {
        kb_layout = "dk";
        numlock_by_default = true;
      };

      windowrulev2 = [
        "noblur, class:([^A][^l][^a][^c][^r][^i][^t][^t][^y])"
        "workspace 10, class:(KeePassXC)"
      ];
    };
    
    extraConfig = ''
      exec-once = ${randomizeWallpaper}

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

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      #workspaces {
        padding: 0;
      }

      #workspaces button {
        padding: 0;
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
          #"mpd"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          #"power-profiles-daemon"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "sway/language"
          "battery"
          "clock"
          "tray"
          #"custom/power"
        ];

        "keyboard-state" = {
            "numlock" = true;
            "capslock" = true;
            "format" = "{name} {icon}";
            "format-icons" = {
                "locked" = "";
                "unlocked" = "";
            };
        };
        "sway/mode" = {
            "format" = "<span style=\"italic\">{}</span>";
        };
        "sway/scratchpad" = {
            "format" = "{icon} {count}";
            "show-empty" = false;
            "format-icons" = ["" ""];
            "tooltip" = true;
            "tooltip-format" = "{app}: {title}";
        };
        "mpd" = {
            "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
            "format-disconnected" = "Disconnected ";
            "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
            "unknown-tag" = "N/A";
            "interval" = 5;
            "consume-icons" = {
                "on" = " ";
            };
            "random-icons" = {
                "off" = "<span color=\"#f53c3c\"></span> ";
                "on" = " ";
            };
            "repeat-icons" = {
                "on" = " ";
            };
            "single-icons" = {
                "on" = "1 ";
            };
            "state-icons" = {
                "paused" = "";
                "playing" = "";
            };
            "tooltip-format" = "MPD (connected)";
            "tooltip-format-disconnected" = "MPD (disconnected)";
        };
        "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
                "activated" = "";
                "deactivated" = "";
            };
        };
        "tray" = {
          #"icon-size" = 21;
            "spacing" = 10;
            # "icons" = {
            #   "blueman" = "bluetooth";
            #   "TelegramDesktop" = "$HOME/.local/share/icons/hicolor/16x16/apps/telegram.png"
            # }
        };
        "clock" = {
            # "timezone" = "America/New_York";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = "{:%Y-%m-%d}";
        };
        "cpu" = {
            "format" = "{usage}% ";
            "tooltip" = false;
        };
        "memory" = {
            "format" = "{}% ";
        };
        "temperature" = {
            # "thermal-zone" = 2;
            # "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
            "critical-threshold" = 80;
            # "format-critical" = "{temperatureC}°C {icon}";
            "format" = "{temperatureC}°C {icon}";
            "format-icons" = ["" "" ""];
        };
        "backlight" = {
            # "device" = "acpi_video1";
            "format" = "{percent}% {icon}";
            "format-icons" = ["" "" "" "" "" "" "" "" ""];
        };
        "battery" = {
            "states" = {
                # "good" = 95;
                "warning" = 30;
                "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            "format-full" = "{capacity}% {icon}";
            "format-charging" = "{capacity}% ";
            "format-plugged" = "{capacity}% ";
            "format-alt" = "{time} {icon}";
            # "format-good" = ""; // An empty format will hide the module
            # "format-full" = "";
            "format-icons" = ["" "" "" "" ""];
        };
        "power-profiles-daemon" = {
          "format" = "{icon}";
          "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
          "tooltip" = true;
          "format-icons" = {
            "default" = "";
            "performance" = "";
            "balanced" = "";
            "power-saver" = "";
          };
        };
        "network" = {
            # "interface" = "wlp2*"; // (Optional) To force the use of this interface
            "format-wifi" = "{essid} ({signalStrength}%) ";
            "format-ethernet" = "{ipaddr}/{cidr} ";
            "tooltip-format" = "{ifname} via {gwaddr} ";
            "format-linked" = "{ifname} (No IP) ";
            "format-disconnected" = "Disconnected ⚠";
            "format-alt" = "{ifname}: {ipaddr}/{cidr}";
        };
        "pulseaudio" = {
            # "scroll-step" = 1; // %, can be a float
            "format" = "{volume}% {icon} {format_source}";
            "format-bluetooth" = "{volume}% {icon} {format_source}";
            "format-bluetooth-muted" = " {icon} {format_source}";
            "format-muted" = " {format_source}";
            "format-source" = "{volume}% ";
            "format-source-muted" = "";
            "format-icons" = {
                "headphone" = "";
                "hands-free" = "";
                "headset" = "";
                "phone" = "";
                "portable" = "";
                "car" = "";
                "default" = ["" "" ""];
            };
            "on-click" = "pavucontrol";
        };
        "custom/media" = {
            "format" = "{icon} {text}";
            "return-type" = "json";
            "max-length" = 40;
            "format-icons" = {
                "spotify" = "";
                "default" = "🎜";
            };
            "escape" = true;
            "exec" = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null"; # Script in resources folder
            # "exec" = "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
        };
        "custom/power" = {
            "format"  = "⏻ ";
    		"tooltip" = false;
    		"menu" = "on-click";
    		"menu-file" = "$HOME/.config/waybar/power_menu.xml"; # Menu file in resources folder
    		"menu-actions" = {
    			"shutdown" = "shutdown";
    			"reboot" = "reboot";
    			"suspend" = "systemctl suspend";
    			"hibernate" = "systemctl hibernate";
    		};
        };
      };
    };
  };

  services.hyprpolkitagent.enable = true;
  programs.hyprlock.enable = true;
  services.hyprpaper.enable = true;
  services.hyprpaper.settings.ipc = "on";

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

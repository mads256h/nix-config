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
      # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprwinwrap
    ];

    settings = {
      mod = {
        _var = "SUPER";
      };

      config = {
        ecosystem.no_update_news = true;
        general = {
          border_size = 0;
          gaps_in = 15;
          gaps_out = 15;
          layout = "hy3";
        };
        decoration = {
          blur = {
            enabled = true;
            size = 4;
            passes = 2;
            xray = true;
          };
          shadow.enabled = false;
        };
        animations.enabled = false;
        input = {
          kb_layout = "dk";
          numlock_by_default = true;
        };
        debug = {
          enable_stdout_logs = true;
          disable_logs = false;
        };
      };

      monitor = {
        output = "";
        mode = "preferred";
        position = "auto";
        scale = "1";
      };

      bind = [
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + Q\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.kill_active()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + E\"")
            (lib.generators.mkLuaInline "hl.dsp.exit()")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + RETURN\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "alacritty -e tmux"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + RETURN\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "alacritty"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + G\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "alacritty -e tmux new-session vifmrun"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + W\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "librewolf"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + S\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "spotify"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + D\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "rofi -show drun"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + T\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.coreutils}/bin/tee ~/Pictures/screenshots/$(date +%s).png | ${pkgs.wl-clipboard}/bin/wl-copy"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + T\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${package}/bin/hyprctl -j activewindow | ${pkgs.jq}/bin/jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"' | ${pkgs.grim}/bin/grim -g - - | ${pkgs.coreutils}/bin/tee ~/Pictures/screenshots/$(date +%s).png | ${pkgs.wl-clipboard}/bin/wl-copy"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + CTRL + T\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.grim}/bin/grim -o \"$(${package}/bin/hyprctl -j activeworkspace | ${pkgs.jq}/bin/jq -r .monitor)\" - | ${pkgs.coreutils}/bin/tee ~/Pictures/screenshots/$(date +%s).png | ${pkgs.wl-clipboard}/bin/wl-copy"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + L\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "hyprlock"})")
          ];
        }
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 10%+"})")
          ];
        }
        {
          _args = [
            "XF86AudioLowerVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"})")
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"})")
          ];
        }
        {
          _args = [
            "XF86AudioMicMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"})")
          ];
        }
        {
          _args = [
            "XF86MonBrightnessUp"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.brightnessctl}/bin/brightnessctl -q set +10%"})")
          ];
        }
        {
          _args = [
            "XF86MonBrightnessDown"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.brightnessctl}/bin/brightnessctl -q set 10%-"})")
          ];
        }
        {
          _args = [
            "XF86AudioPrev"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.playerctl}/bin/playerctl -p spotify previous"})")
          ];
        }
        {
          _args = [
            "XF86AudioNext"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.playerctl}/bin/playerctl -p spotify next"})")
          ];
        }
        {
          _args = [
            "XF86AudioPlay"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.playerctl}/bin/playerctl -p spotify play-pause"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + ALT + LEFT\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.playerctl}/bin/playerctl -p spotify previous"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + ALT + RIGHT\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.playerctl}/bin/playerctl -p spotify next"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + ALT + UP\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.playerctl}/bin/playerctl -p spotify play-pause"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + ALT + DOWN\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${pkgs.playerctl}/bin/playerctl -p spotify play-pause"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + SPACE\"")
            (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + F\"")
            (lib.generators.mkLuaInline "hl.dsp.window.fullscreen({ mode = \"fullscreen\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + LEFT\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_focus(\"l\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + RIGHT\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_focus(\"r\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + UP\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_focus(\"u\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + DOWN\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_focus(\"d\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + H\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.make_group(\"h\", { ephemeral = true })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + V\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.make_group(\"v\", { ephemeral = true })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:10\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"1\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:11\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"2\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:12\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"3\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:13\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"4\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:14\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"5\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:15\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"6\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:16\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"7\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:17\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"8\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:18\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"9\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + code:19\"")
            (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = \"10\" })")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:10\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"1\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:11\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"2\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:12\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"3\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:13\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"4\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:14\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"5\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:15\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"6\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:16\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"7\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:17\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"8\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:18\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"9\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + SHIFT + code:19\"")
            (lib.generators.mkLuaInline "hl.plugin.hy3.move_to_workspace(\"10\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + CTRL + LEFT\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${package}/bin/hyprctl dispatch movecurrentworkspacetomonitor l"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + CTRL + RIGHT\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(${builtins.toJSON "${package}/bin/hyprctl dispatch movecurrentworkspacetomonitor r"})")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + R\"")
            (lib.generators.mkLuaInline "hl.dsp.submap(\"resize\")")
          ];
        }
        {
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + mouse:272\"")
            (lib.generators.mkLuaInline "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }
      ];

      define_submap = {
        _args = [
          "resize"
          (lib.generators.mkLuaInline ''
            function()
              hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
              hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
              hl.bind("up", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
              hl.bind("down", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
              hl.bind("escape", hl.dsp.submap("reset"))
            end
          '')
        ];
      };

      workspace_rule = [
        {
          workspace = "w[tv1]";
          gaps_out = 0;
          gaps_in = 0;
        }
        {
          workspace = "f[1]";
          gaps_out = 0;
          gaps_in = 0;
        }
      ];

      window_rule = [
        {
          match.class = "gamescope";
          immediate = true;
        }
        {
          match.class = "cs2";
          immediate = true;
        }
        {
          match.class = "negative:^Alacritty$";
          no_blur = true;
        }
        {
          match.class = "spotify";
          workspace = "2";
        }
        {
          match.class = "KeePassXC";
          workspace = "10";
        }
        {
          match.class = "^(ueberzugpp_.*)$";
          float = true;
        }
        {
          match.class = "^(ueberzugpp_.*)$";
          no_initial_focus = true;
        }
        {
          match.class = "^(ueberzugpp_.*)$";
          suppress_event = "fullscreen maximize activate activatefocus";
        }
        {
          match.class = "^(ueberzugpp_.*)$";
          content = "photo";
        }
        {
          match.class = "^(ueberzugpp_.*)$";
          move = "9999 9999";
        }
        {
          match.class = "^(ueberzugpp_.*)$";
          no_focus = true;
        }
      ];
    };

    extraConfig = ''
      ok_file = io.open("hypr_loaded_ok", "w")
      ok_file:write("OK")
      ok_file:close()
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
  home.pointerCursor.enable = true;
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
  services.hyprpaper.enable = true;
  services.hyprpaper.settings.ipc = "on";

  systemd.user.services.hyprpaper.Service.ExecStartPost =
    "${pkgs.writeShellScript "random-wallpaper" ''
      #!${pkgs.bash}/bin/bash

      ${pkgs.coreutils}/bin/sleep 5s

      WALLPAPER_DIR="$HOME/Pictures/wallpapers/"
      WALLPAPER=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f | ${pkgs.coreutils}/bin/shuf -n 1)

      ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper ,"$WALLPAPER"
    ''}";

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

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  home.sessionVariables.NIXOS_OZONE_WL = 1;
}

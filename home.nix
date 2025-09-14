{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  home.username = "mads";
  home.homeDirectory = "/home/mads";

  home.stateVersion = "25.05";

  xdg.enable = true;
  xdg.autostart.enable = true;

  home.packages = [
    pkgs.gcr
  ];

  home.sessionVariables.NIXOS_OZONE_WL = 1;


  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userEmail = "mail@madsmogensen.dk";
    userName = "mads256h";
  };
  
  programs.bash = {
    enable = true;
  };
  home.shell.enableBashIntegration = true;

  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 30000;
    escapeTime = 0;
    focusEvents = true;
    plugins = [
      pkgs.tmuxPlugins.fpp
      pkgs.tmuxPlugins.urlview
    ];
    extraConfig = ''
      set -g status off
      '';
  };

  home.file.".urlview" = {
    enable = true;
    text = "COMMAND ${pkgs.librewolf}/bin/librewolf";
  };


  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*".extraOptions.UseRoaming = "no";
      "github.com".identityFile = "~/.ssh/github_rsa";
      "home.madsmogensen.dk" = {
        identityFile = "~/.ssh/server_rsa";
        user = "root";
        port = 2222;
      };
      "server-mads.lan" = {
        identityFile = "~/.ssh/server_rsa";
        user = "root";
      };
      "desktop-mads.router.lan" = {
        identityFile = "~/.ssh/desktop_rsa";
      };
      "digitalocean 142.93.101.55" = {
        identityFile = "~/.ssh/digitalocean_ed25519";
        user = "root";
        hostname = "142.93.101.55";
      };
    };
  };

  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    maxCacheTtl = 3600 * 24;
    maxCacheTtlSsh = 3600 * 24;
    extraConfig = "allow-preset-passphrase";
    pinentry.package = pkgs.pinentry-gnome3;
  };


  programs.keepassxc = {
    enable = true;
    settings = {
      General = {
        UseAtomicSaves = false;
        BackupBeforeSave = true;
        BackupFilePathPattern = "/home/mads/Backup/{DB_FILENAME}.old.kdbx";
      };
      GUI = {
        ApplicationTheme = "classic";
        CompactMode = true;
      };
      Browser.Enabled = true;
      PasswordGenerator = {
        Length = 64;
        SpecialChars = true;
        WordList = "eff_large.wordlist";
      };
    };
    autostart = true;
  };


  programs.alacritty = {
    enable = true;
    settings.window = {
      opacity = lib.mkForce 0.8;
      blur = true;
    };
    settings.scrolling.history = 0;
  };
  programs.waybar = {
    enable = true;
    systemd.enable = true;
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
  programs.rofi.enable = true;
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
        "workspace 10, class:(KeePassXC)"
      ];
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
  services.hyprpolkitagent.enable = true;
  programs.hyprlock.enable = true;

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

  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    withPython3 = false;
    withRuby = false;

    opts = {
      number = true;
      relativenumber = true;

      autoindent = true;
      copyindent = true;
      expandtab = true;
      shiftround = true;
      shiftwidth = 2;
      smartindent = true;
      smarttab = true;
      softtabstop = 2;
      tabstop = 2;
    };

    highlightOverride = {
      Normal = { bg = "none"; ctermbg = "none"; };
      NonText = { bg = "none"; ctermbg = "none"; };
      SignColumn = { bg = "none"; ctermbg = "none"; };
      LineNr = { bg = "none"; ctermbg = "none"; };
      LineNrAbove = { bg = "none"; ctermbg = "none"; };
      LineNrBelow = { bg = "none"; ctermbg = "none"; };
    };

    keymaps = [
      {
        mode = "n";
        key = "<c-c>";
        action = ''"+yy'';
        options = { noremap = true; silent = true; };
      }
      {
        mode = "v";
        key = "<c-c>";
        action = ''"+y'';
        options = { noremap = true; silent = true; };
      }
      {
        mode = "n";
        key = "<c-v>";
        action = ''"+p'';
        options = { noremap = true; silent = true; };
      }
    ];

    plugins.lualine.enable = true;

    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
    plugins.treesitter-context.enable = true;
    plugins.treesitter-textobjects.enable = true;
    plugins.lspconfig.enable = true;
    plugins.cmp = {
      enable = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
        ];

        snippet = {
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
            '';
        };

        mapping = {
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = ''
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }
            '';
          "<Tab>" = ''
            function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
              else
                fallback()
              end
            end
            '';
          "<S-Tab>" = ''
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
              else
                fallback()
              end
            end
            '';
        };
      };
    };
    lsp.servers.nixd = {
      enable = true;
      settings.settings = {
        nixpkgs = {
          # For flake.
          # This expression will be interpreted as "nixpkgs" toplevel
          # Nixd provides package, lib completion/information from it.
          # Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
          # Package documentation, versions, are evaluated by-need.
          expr = "import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }";
        };
        # formatting = {
        #     command = { "alejandra" }, -- or nixfmt or nixpkgs-fmt
        # },
        options = {
          nixos = {
            expr = ''let flake = builtins.getFlake(toString ./.); in flake.nixosConfigurations."laptop-mads".options'';
          };
          home_manager = {
            expr = ''let flake = builtins.getFlake(toString ./.); in flake.nixosConfigurations."laptop-mads".options.home-manager.users.type.getSubOptions []'';
          };
        };
      };
    };
    lsp.servers.bashls.enable = true;
    lsp.servers.systemd_ls.enable = true;
    lsp.servers.jsonls.enable = true;
    lsp.servers.clangd.enable = true;
    lsp.servers.cmake.enable = true;
    lsp.servers.rust_analyzer.enable = true;
    lsp.servers.pyright.enable = true;
    lsp.servers.ts_ls.enable = true;
    lsp.servers.cssls.enable = true;
    lsp.servers.eslint.enable = true;
    lsp.servers.html.enable = true;
    lsp.servers.omnisharp.enable = true;
    plugins.lspkind.enable = true;
    plugins.luasnip.enable = true;
    plugins.lsp-signature.enable = true;
    plugins.cmp-nvim-lsp.enable = true;
    plugins.gitsigns.enable = true;
    plugins.gitsigns.settings.signs = {
      add = { text = "+"; };
      change = { text = "~"; };
      delete = { text = "_"; };
      topdelete = { text = "‾"; };
      changedelete = { text = "~"; };
    };
  };

  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
  };
}

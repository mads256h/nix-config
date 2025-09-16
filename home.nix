{ config, pkgs, lib, inputs, stylix, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./home/hyprland.nix
    ./home/neovim.nix
    ./home/ssh.nix
    ./home/vifm.nix
    ./home/mpv.nix
  ];

  home.username = "mads";
  home.homeDirectory = "/home/mads";

  home.stateVersion = "25.05";

  xdg.enable = true;
  xdg.autostart.enable = true;

  home.packages = [
    pkgs.gcr
    pkgs.tremc
    pkgs.libreoffice-fresh
    pkgs.vifmimg
    pkgs.ueberzugpp
  ];


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

  programs.zathura.enable = true;
  programs.imv.enable = true;


  programs.alacritty = {
    enable = true;
    settings.window = {
      opacity = lib.mkForce 0.8;
      blur = true;
    };
    settings.scrolling.history = 0;
  };

  programs.rofi.enable = true;


  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
  };

  fonts.fontconfig.enable = true;
  fonts.fontconfig.subpixelRendering = "rgb";
}

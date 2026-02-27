{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.spicetify
    ./hyprland.nix
    ./mpv.nix
    ./accounts.nix
    ./librewolf.nix
    ./thunderbird.nix
  ];

  home.packages = with pkgs; [
    gcr
    tremc
    libreoffice-fresh
    vifmimg
    ueberzugpp
    seahorse
    libsecret
    pulsemixer
    wineWowPackages.waylandFull
    winetricks
    prismlauncher
    easytag
    imagemagick
    renderdoc
    jetbrains.rust-rover
    pcmanfm
    steamtinkerlaunch
  ];

  # Enable for websites incompatible with librewolf (default config)
  programs.chromium.enable = true;

  programs.spicetify = {
    enable = true;
    # enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}.extensions; [
    #   goToSong
    #   betterGenres
    #   keyboardShortcut
    #   shuffle
    #   trashbin
    # ];
    enabledSnippets = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system}.snippets; [
      removeGradient
      hideDownloadButton
      modernScrollbar
    ];
    alwaysEnableDevTools = true;
  };

  stylix.targets.spicetify.enable = false;

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
      Security.IconDownloadFallback = true;
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

  home.sessionVariables = {
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
  };

  programs.rofi.enable = true;

  programs.mangohud.enable = true;

  fonts.fontconfig.enable = true;
  #fonts.fontconfig.subpixelRendering = "rgb";

  home.sessionVariables._JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java -Dawt.useSystemAAFontSettings=gasp -Dswing.aatext=true -Djdk.downloader.home=$XDG_DATA_HOME/jdks -Djavafx.cachedir=$XDG_CACHE_HOME/openjfx";

  services.gnome-keyring.enable = true;
  services.gnome-keyring.components = [ "secrets" ];

  services.protonmail-bridge.enable = true;
  services.protonmail-bridge.extraPackages = [ pkgs.gnome-keyring ];

  services.blueman-applet.enable = true;
}

{ pkgs, lib, inputs, ... }:
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
  ];

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

  fonts.fontconfig.enable = true;
  fonts.fontconfig.subpixelRendering = "rgb";

  services.gnome-keyring.enable = true;
  services.gnome-keyring.components = [ "secrets" ];

  services.protonmail-bridge.enable = true;
  services.protonmail-bridge.extraPackages = [ pkgs.gnome-keyring ];
}

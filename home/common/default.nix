{ config, lib, inputs, pkgs, sysconfig, ... }:
{
  imports = [
    ./bash.nix
    ./neovim.nix
    ./vifm.nix
    ./ssh.nix
  ];

  home.username = "mads";
  home.homeDirectory = "/home/mads";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  xdg.enable = true;
  #xdg.autostart.readOnly = true;
  xdg.autostart.enable = true;
  xdg.mimeApps.enable = true;

  home.packages = with pkgs; [
    shellcheck
    yt-dlp
    unzip
    p7zip
    xdg-utils
    glib
    jq
  ];


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
      set-window-option -g mode-keys vi
      '';
  };
  stylix.targets.tmux.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.email = "mail@madsmogensen.dk";
      user.name = "mads256h";
      init.defaultBranch = "master";
      pull.rebase = true;
      merge.tool = "vimdiff";
      commit.verbose = true;
      diff.algorithm = "histogram";
      submodule.recurse = true;

      user.signingKey = "75C8BC5DCCE7257DA133C6CECCD33BA72D54F208";
      commit.gpgSign = sysconfig.graphical;
      tag.gpgSign = sysconfig.graphical;

      # Use ssh instead of http
      url."git@bitbucket.org:".insteadOf = "https://bitbucket.org/";
    };
  };

  programs.htop = {
    enable = true;
    package = pkgs.htop-vim;
    settings = {
      hide_userland_threads = true;
      show_cpu_frequency = true;
      show_cpu_temperature = true;
      highlight_base_name = true;
    };
  };
}

{ config, lib, inputs, pkgs, sysconfig, ... }:
{
  imports = [
    ./neovim.nix
    ./vifm.nix
    ./ssh.nix
  ];

  home.username = "mads";
  home.homeDirectory = "/home/mads";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  xdg.enable = true;
  #xdg.autostart.readOnly = true;
  xdg.autostart.enable = true;

  home.packages = with pkgs; [
    shellcheck
    yt-dlp
    unzip
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

  programs.bash = {
    enable = true;
    initExtra = ''
      source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
      GIT_PS1_SHOWDIRTYSTATE=auto
      GIT_PS1_SHOWSTASHSTATE=auto
      GIT_PS1_SHOWUNTRACKEDFILES=auto
      GIT_PS1_SHOWUPSTREAM=auto
      GIT_PS1_COMPRESSSPARSESTATE=auto
      export PS1="\[\e[0m\]\[\e[31m\][\[\e[32m\]\u\[\e[0m\]@\[\e[34m\]\h \[\e[33m\]\W\[\e[36m\]\$(__git_ps1)\[\e[31m\]]\[\e[0m\]\\$ \[\e[0m\]"

      '' + lib.optionalString sysconfig.graphical ''
      # Start hyprland automagically on tty1
      if [ -z "''${WAYLAND_DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ]; then
        exec hyprland
      fi
      '';
  };
  home.shell.enableBashIntegration = true;

  programs.git = {
    enable = true;
    userEmail = "mail@madsmogensen.dk";
    userName = "mads256h";
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      merge.tool = "vimdiff";
      commit.verbose = true;
      diff.algorithm = "histogram";

      user.signingKey = "75C8BC5DCCE7257DA133C6CECCD33BA72D54F208";
      commit.gpgSign = true;
      tag.gpgSign = true;
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

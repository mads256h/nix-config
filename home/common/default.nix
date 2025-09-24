{ config, lib, inputs, pkgs, sysconfig, ... }:
{
  imports = [
    ./neovim.nix
    ./vifm.nix
  ];

  home.username = "mads";
  home.homeDirectory = "/home/mads";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  xdg.enable = true;
  #xdg.autostart.readOnly = true;
  xdg.autostart.enable = true;


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
  stylix.targets.tmux.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      export PS1="\[\e[0m\]\[\e[31m\][\[\e[32m\]\u\[\e[0m\]@\[\e[34m\]\h \[\e[33m\]\W\[\e[31m\]]\[\e[0m\]\\$ \[\e[0m\]"

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
  };
}

{ config, lib, inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./neovim.nix
  ];

  home.username = "mads";
  home.homeDirectory = "/home/mads";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.shell.enableBashIntegration = true;

  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 30000;
    escapeTime = 0;
    focusEvents = true;
    extraConfig = ''
      set -g status off
      '';
  };

  programs.bash = {
    enable = true;
    initExtra = lib.mkDefault ''
      export PS1="\[\e[0m\]\[\e[31m\][\[\e[32m\]\u\[\e[0m\]@\[\e[34m\]\h \[\e[33m\]\W\[\e[31m\]]\[\e[0m\]\\$ \[\e[0m\]"
      '';
  };

  programs.git = {
    enable = true;
    userEmail = lib.mkDefault "mail@madsmogensen.dk";
    userName = lib.mkDefault "mads256h";
  };
}

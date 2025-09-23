{ config, lib, inputs, pkgs, ... }:
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
    plugins = [
      pkgs.tmuxPlugins.fpp
      pkgs.tmuxPlugins.urlview
    ];
    extraConfig = ''
      set -g status off
      '';
  };

  programs.bash = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userEmail = lib.mkDefault "mail@madsmogensen.dk";
    userName = lib.mkDefault "mads256h";
  };
}

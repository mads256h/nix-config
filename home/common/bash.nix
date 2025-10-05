{ pkgs, lib, sysconfig, ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      "cs" = ''ssh server-mads.lan; test "$?" -eq 255 && ssh home.madsmogensen.dk'';

      "yt" = "yt-dlp -f bestvideo+bestaudio --add-metadata --embed-subs --all-subs";
      "yta" = "yt --download-archive .archive";
      "ytmp3" = "yt-dlp -f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --add-metadata";

      "tremc" = "tremc -c server-mads.lan";
    };
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
}

{
  config,
  pkgs,
  lib,
  sysconfig,
  ...
}:
let
  vifmimg = "${pkgs.vifmimg}/bin/vifmimg";
  pdfViewer = "${pkgs.zathura}/bin/zathura";
  mpv = "${pkgs.mpv}/bin/mpv";
  imageViewer = "${pkgs.imv}/bin/imv";
  browser = "${pkgs.librewolf}/bin/librewolf";
  torrentClient = "${pkgs.tremc}/bin/tremc";
  office = "${pkgs.libreoffice-fresh}/bin/libreoffice";

  bash = "${pkgs.bash}/bin/bash";
  file = "${pkgs.file}/bin/file";
  cut = "${pkgs.coreutils}/bin/cut";
  grep = "${pkgs.gnugrep}/bin/grep";
  cat = "${pkgs.coreutils}/bin/cat";

  zip = "${pkgs.zip}/bin/zip";
  tar = "${pkgs.gnutar}/bin/tar";
  xz = "${pkgs.xz}/bin/xz";
  unrar = "${pkgs.unrar}/bin/unrar";
  z7 = "${pkgs.p7zip}/bin/7z";

  jq = "${pkgs.jq}/bin/jq";
  pygmentize = "${pkgs.python313Packages.pygments}/bin/pygmentize";

  outputOrFile = pkgs.writeTextFile {
    name = "output-or-file";
    executable = true;
    text = ''
      #!${bash}
      if ${file} -L "$1" | ${cut} -d ':' -f 2- | ${cut} -d ' ' -f 2- | ${grep} -q 'text\|ASCII\|Unicode'; then
        ${cat} "$1"
      else
        ${file} -L "$1" | ${cut} -d ':' -f 2- | ${cut} -d ' ' -f 2-
      fi
    '';
  };

  previewGraphical = lib.optionalString sysconfig.graphical pkgs.writeTextFile {
    name = "vifm-preview-graphical-config";
    text = ''
      " pdf
      fileviewer {*.pdf},<application/pdf>
        \ ${vifmimg} pdf %px %py %pw %ph %c
        \ %pc
        \ ${vifmimg} clear

      " audio
      fileviewer {*.wav,*.mp3,*.aif},<audio/*>
        \ ${vifmimg} audio %px %py %pw %ph %c
        \ %pc
        \ ${vifmimg} clear

      " video
      fileviewer {*.avi,*.mp4,*.wmv,*.dat,*.3gp,*.ogv,*.mkv,*.mpg,*.mpeg,*.vob,*.fl[icv],*.m2v,*.mov,*.webm,*.ts,*.mts,*.m4v,*.r[am],*.qt,*.divx,*.as[fx],*.bik,*.bik2,*.bk2},<video/*>
        \ ${vifmimg} video %px %py %pw %ph %c
        \ %pc
        \ ${vifmimg} clear

      " images
      fileviewer {*.bmp,*.jpg,*.jpeg,*.gif,*.png,*.xpm},<image/*>
        \ ${vifmimg} draw %px %py %pw %ph %c
        \ %pc
        \ ${vifmimg} clear

      " icons
      fileviewer {*.bmp,*.jpg,*.jpeg,*.gif,*.png,*.xpm},<image/*>
        \ ${vifmimg} draw %px %py %pw %ph %c
        \ %pc
        \ ${vifmimg} clear
    '';
  };

  preview = pkgs.writeTextFile {
    name = "vifm-preview-config";
    text = ''
      " archives
      fileviewer {*.zip,*.jar,*.war,*.ear,*.oxt},<application/zip,application/java-archive>
        \ ${zip} -sf %c

      fileviewer {*.tgz,*.tar.gz}
        \ ${tar} -tzf %c

      fileviewer {*.tar.bz2,*.tbz2}
        \ ${tar} -tjf %c

      fileviewer {*.tar.txz,*.txz}
        \ ${xz} --list %c

      fileviewer {*.tar.zst,*.zst}
        \ ${tar} -t --zstd -f %c

      fileviewer {*.tar},<application/x-tar>
        \ ${tar} -tf %c

      fileviewer {*.rar},<application/x-rar>
        \ ${unrar} vb %c

      fileviewer {*.7z},<application/x-7z-compressed>
        \ ${z7} l %c

      " json
      fileviewer {*.json},<application/json,text/json>
        \ ${jq} -C . %c


      " code highlighting
      fileviewer {*.js,*.c,*.h,*.cpp,*.hpp,*.sh,*.bash,*.cs,*.rs,*.xml,*.py,*.tex,CMakeLists.txt,*.toml,*.yml,*.yaml,*.lua,*.css,*.html,*.md,*.nix,*.proto,*.diff,PKGBUILD},<application/x-shellscript>,<text/x-shellscript>,<text/x-perl>
        \ ${pygmentize} -O style=monokai -g

      " everything else
      fileviewer *[^/]
        \ ${outputOrFile} %f
    '';
  };

  openWith = lib.optionalString sysconfig.graphical pkgs.writeTextFile {
    name = "vifm-open-with-config";
    text = ''
      " pdf, postscript, djvu
      filextype {*.pdf,*.ps,*.eps,*.ps.gz,*.djvu},<application/pdf>,<application/postscript>,<image/vn.djvu>
        \ {View in zathura}
        \ ${pdfViewer} %f %i 2>/dev/null

      " audio
      filetype {*.wav,*.mp3,*.flac,*.m4a,*.wma,*.ape,*.ac3,*.og[agx],*.spx,*.opus,*.aif},<audio/*>
        \ {Play using mpv}
        \ ${mpv} %f

      " video
      filextype {*.avi,*.mp4,*.wmv,*.3gp,*.ogv,*.mkv,*.mpg,*.mpeg,*.vob,*.fl[icv],*.m2v,*.mov,*.webm,*.ts,*.mts;*.m4v,*.r[am],*.qt,*.divx,*.as[fx],*.bik,*.bik2,*.bk2},<video/*>
        \ {View using mpv}
        \ ${mpv} %f

      " gif
      filextype {*.gif},<image/gif>
        \ {View using mpv}
        \ ${mpv} %f --loop-file=inf

      " images
      filextype {*.bmp,*.jpg,*.jpeg,*.png,*.xpm},<image/*>
        \ {View in imv}
        \ ${imageViewer} %f

      " web
      filextype {*.html,*.htm},<text/html>
        \ {Open in browser}
        \ ${browser} %f %i 2>/dev/null

      " torrent
      filetype {*.torrent},<application/x-bittorrent>
        \ {Open in torrent client}
        \ ${torrentClient} %f

      " office
      filextype {*.odt,*.doc,*.docx,*.xls,*.xlsx,*.odp,*.pptx,*.ppt},<application/vnd.openxmlformats-officedocument.*,application/msword,application/vnd.ms-excel>
        \ {Open in libreoffice}
        \ ${office} %f %i 2>/dev/null
    '';
  };
in
{
  programs.vifm.enable = true;

  home.packages = [
    pkgs.ueberzugpp
  ];

  home.file.".config/vifm/vifmrc" = {
    enable = true;
    text = ''
      ${lib.optionalString sysconfig.graphical "so ${previewGraphical}"}
      so ${preview}
      ${lib.optionalString sysconfig.graphical "so ${openWith}"}

      set vicmd=nvim
      set syscalls
      set history=100
      set sortnumbers
      set vimhelp
      set timefmt=%F\ %H:%M:%S
      set wildmenu
      set wildstyle=popup
      set suggestoptions=normal,visual,view,otherpane,keys,marks,registers
      set ignorecase
      set smartcase
      set sort=iname
      set incsearch
      set dotfiles
      set previewoptions+=graphicsdelay:0
      set viewcolumns=-{name},-15{perms},15{mtime},9{size}
      set slowfs+=/home/mads/mnt

      set statusline="  %{system('git show -s --pretty=%d HEAD 2>/dev/null')}%= %A %10u:%-7g %15s %20d  "

      command! dragon ${pkgs.dragon-drop}/bin/dragon-drop -a -x %f
      nmap <C-d> :dragon<CR>

      nnoremap s :!tmux new-window && tmux send-keys -t 1 'cd %d && clear' ENTER<cr>

      " Mappings for faster renaming
      nnoremap I cw<c-a>
      nnoremap cc cw<c-u>
      nnoremap A cw

      " Next and Prev pdf page
      map > :!${vifmimg} inc<CR>
      map < :!${vifmimg} dec<CR>

      " theme
      hi Win cterm=none ctermfg=default ctermbg=default
      hi Border cterm=none ctermfg=default ctermbg=default
      hi TopLine cterm=bold ctermfg=default ctermbg=black
      hi StatusLine cterm=bold ctermfg=default ctermbg=black

      view
    '';
  };

  xdg.desktopEntries = lib.optionalAttrs sysconfig.graphical {
    # Taken from vifm.desktop
    vifm = {
      categories = [
        "System"
        "FileManager"
        "Utility"
        "ConsoleOnly"
      ];
      comment = "Vim-like ncurses based file manager";
      genericName = "File Manager";
      name = "Vifm";
      icon = "Vifm";
      exec = "vifmrun %F";
      terminal = true;
      type = "Application";
      mimeType = [ "inode/directory" ];
    };
  };

  xdg.mimeApps.defaultApplications."inode/directory" = lib.mkForce [ "vifm.desktop" ];
}

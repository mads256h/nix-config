{ config, pkgs, lib, ... }:
let
  vifmimg = "${pkgs.vifmimg}/bin/vifmimg";
  pdfViewer = "${pkgs.zathura}/bin/zathura";
  mpv = "${pkgs.mpv}/bin/mpv";
  imageViewer = "${pkgs.imv}/bin/imv";
  browser = "${pkgs.librewolf}/bin/librewolf";
  torrentClient = "${pkgs.tremc}/bin/tremc";
  office = "${pkgs.libreoffice-fresh}/bin/libreoffice";

  preview = pkgs.writeTextFile {
    name = "vifm-preview-config";
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

  openWith = pkgs.writeTextFile {
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
      so ${preview}
      so ${openWith}

      set vicmd=${pkgs.neovim}/bin/nvim
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
      set incsearch
      set previewoptions+=graphicsdelay:0
      set viewcolumns=-{name},-15{perms},15{mtime},9{size}
      set slowfs+=/home/mads/mnt

      command! dragon ${pkgs.dragon-drop}/bin/dragon-drop -a -x %f
      nmap <C-d> :dragon<CR>

      nnoremap s :shell<cr>

      " Mappings for faster renaming
      nnoremap I cw<c-a>
      nnoremap cc cw<c-u>
      nnoremap A cw

      " Next and Prev pdf page
      map > :!${vifmimg} inc<CR>
      map < :!${vifmimg} dec<CR>

      view
      '';
  };
}

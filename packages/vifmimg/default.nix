{ stdenv, lib, fetchFromGitHub, makeWrapper, vifm, ueberzugpp, ffmpegthumbnailer, epub-thumbnailer, poppler-utils, djvulibre, ffmpeg, fontpreview, coreutils, ... }:

stdenv.mkDerivation rec {
  version = "unstable-2024-01-16-1";
  pname = "vifmimg";

  src = fetchFromGitHub {
    owner = "thimc";
    repo = "vifmimg";
    rev = "8ba24fc724505582015203f257c71b9d8a30454f";
    hash = "sha256-Am0nIZm2B6N5lX/Zq2dzUTag0BXOnbcwuz8BfylYSbQ=";
  };

  #configurePhase = "";

  #buildInputs = [ vifm ueberzugpp ffmpegthumbnailer epub-thumbnailer poppler-utils djvulibre ffmpeg fontpreview ];

  buildInputs = [ makeWrapper ];

  buildPhase = ''
    mkdir -p $out/bin
    cp vifm* $out/bin
  '';

  installPhase = ''
    wrapProgram $out/bin/vifmimg \
      --set PATH ${lib.makeBinPath [ vifm ueberzugpp ffmpegthumbnailer epub-thumbnailer poppler-utils djvulibre ffmpeg fontpreview coreutils ]}:$out/bin:$PATH
      #wrapProgram $out/bin/vifmrun \
      #--set PATH ${lib.makeBinPath [ vifm ueberzugpp ]}:$out/bin:$PATH
  '';
}

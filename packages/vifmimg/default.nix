{ stdenv, lib, fetchFromGitHub, vifm, ueberzugpp, ffmpegthumbnailer, epub-thumbnailer, poppler-utils, djvulibre, ffmpeg, fontpreview, ... }:

stdenv.mkDerivation rec {
  version = "unstable-2024-01-16";
  pname = "vifmimg";

  src = fetchFromGitHub {
    owner = "thimc";
    repo = "vifmimg";
    rev = "8ba24fc724505582015203f257c71b9d8a30454f";
    sha256 = "11pbfayww7pwyk8a7jgvijx9i96ahyvn5y84gpn0yjd0b9wf75bn";
  };

  buildInputs = [ vifm ueberzugpp ffmpegthumbnailer epub-thumbnailer poppler-utils djvulibre ffmpeg fontpreview ];
  installPhase = ''
    mkdir -p $out/bin
    cp vifm* $out/bin
  '';

  postInstall = ''
    wrapProgram $out/bin/vifmimg \
      --prefix PATH : ${lib.makeBinPath [ vifm ueberzugpp ffmpegthumbnailer epub-thumbnailer poppler-utils djvulibre ffmpeg fontpreview ]}
    wrapProgram $out/bin/vifmrun \
      --prefix PATH : ${lib.makeBinPath [ vifm ueberzugpp ]}
  '';
}

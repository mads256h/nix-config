final: prev: {
  st = prev.st.overrideAttrs (oldAttrs: {
    conf = builtins.readFile ./config.def.h;
    patches = [
      ./st-background-image-0.8.5.diff
      ./st-xresources-signal-reloading-20220407-ef05519.diff
      ./st-boxdraw_v2-0.8.5.diff
      ./st-dynamic-cursor-color-0.9.diff
      ./st-undercurl-0.9-20240103.diff
      ./st-csi_22_23-0.8.5.diff
      ./update-bg-on-reload.diff
    ];
    version = "0.9.1";
    src = prev.fetchzip {
      url = "https://dl.suckless.org/st/st-0.9.1.tar.gz";
      hash = "sha256-3INKvohoSCIqE+Wje9wmwxejR1PZ2ONkhxJmbN0hbdY=";
    };
  });
}

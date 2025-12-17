{
  config,
  pkgs,
  sysconfig,
  ...
}:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
    fonts.sizes.applications = 10;
    fonts.sizes.terminal = 11;
    fonts.serif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    fonts.sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    fonts.monospace = {
      package = pkgs.nerd-fonts.hack;
      name = "Hack Nerd Font";
    };
    fonts.emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "Breeze";
      size = 32;
    };

    autoEnable = sysconfig.graphical; # Only enable specific stuff on non-graphical environments
  };
}

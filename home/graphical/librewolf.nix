{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
    profiles.default = {
      isDefault = true;
    };
  };

  stylix.targets.librewolf.profileNames = [ "default" ];

  home.file.".urlview" = {
    enable = true;
    text = "COMMAND ${pkgs.librewolf}/bin/librewolf";
  };
}

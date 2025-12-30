{ pkgs, ... }:
{
  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = [ pkgs.keepassxc ];
    profiles.default = {
      isDefault = true;
      settings = {
        "privacy.clearOnShutdown.cookies" = false;
        "privacy.clearOnShutdown.sessions" = false;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
      };
    };
  };

  stylix.targets.librewolf.profileNames = [ "default" ];

  home.file.".urlview" = {
    enable = true;
    text = "COMMAND ${pkgs.librewolf}/bin/librewolf";
  };

  home.sessionVariables = {
    BROWSER = "${pkgs.librewolf}/bin/librewolf";
  };
}

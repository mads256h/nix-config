{ ... }:
{
  imports = [
    ../../home/common
  ];

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com".identityFile = "~/.ssh/github_personal_rsa";

      "bitbucket.org" = {
        user = "git";
        identityFile = "~/.ssh/bitbucket_rsa";
      };

      "*.ibmgst" = {
        user = "mbmo";
        identityFile = "~/.ssh/mbmo_gst_servere_rsa";
      };

      "*.resdmz.dmzroot.dk" = {
        user = "y166261";
        identityFile = "~/.ssh/mbmo_sit_servere_rsa";
      };
    };
  };

  home.file.".urlview" = {
    enable = true;
    text = "COMMAND /mnt/c/WINDOWS/explorer.exe";
  };
}

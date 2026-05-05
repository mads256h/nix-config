{ lib, pkgs, ... }:
{
  imports = [ ../../home/common ];

  programs.ssh.matchBlocks = {
    "bitbucket.org" = {
      user = "git";
      identityFile = "~/.ssh/bitbucket_rsa";
    };

    "*.ibmgst.dk" = {
      user = "mbmo";
      identityFile = "~/.ssh/mbmo_gst_servere_rsa";
    };

    "*.resdmz.dmzroot.dk" = {
      user = "y166261";
      identityFile = "~/.ssh/mbmo_sit_servere_rsa";
    };
  };

  home.packages = with pkgs; [
    ibmcloud-cli
    jira-cli-go
  ];

  home.file.".urlview" = {
    enable = true;
    text = "COMMAND /mnt/c/WINDOWS/explorer.exe";
  };

  programs.git.settings.user = {
    email = lib.mkForce "mbmo@netcompany.com";
    name = lib.mkForce "Mads Beyer Mogensen";
  };

  programs.gpg.settings = {
    "pinentry-mode" = "loopback";
  };

  services.gpg-agent.grabKeyboardAndMouse = false;
}

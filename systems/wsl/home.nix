{ lib, pkgs, ... }:
{
  imports = [ ../../home/common ];

  programs.ssh.settings = {
    "bitbucket.org" = {
      User = "git";
      IdentityFile = "~/.ssh/bitbucket_rsa";
    };

    "*.ibmgst.dk" = {
      User = "mbmo";
      IdentityFile = "~/.ssh/mbmo_gst_servere_rsa";
    };

    "*.resdmz.dmzroot.dk" = {
      User = "y166261";
      IdentityFile = "~/.ssh/mbmo_sit_servere_rsa";
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

  home.pointerCursor.enable = false;

  programs.git.settings.user = {
    email = lib.mkForce "mbmo@netcompany.com";
    name = lib.mkForce "Mads Beyer Mogensen";
  };

  programs.gpg.settings = {
    "pinentry-mode" = "loopback";
  };

  services.gpg-agent.grabKeyboardAndMouse = false;
}

{ pkgs, sysconfig, lib, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*".extraOptions.UseRoaming = "no";
      "github.com".identityFile = "~/.ssh/github_rsa";
      "home.madsmogensen.dk" = {
        identityFile = "~/.ssh/server_rsa";
        user = "root";
        port = 2222;
      };
      "server-mads.lan" = {
        identityFile = "~/.ssh/server_rsa";
        user = "root";
      };
      "desktop-mads.router.lan" = {
        identityFile = "~/.ssh/desktop_rsa";
      };
      "digitalocean 142.93.101.55" = {
        identityFile = "~/.ssh/digitalocean_ed25519";
        user = "root";
        hostname = "142.93.101.55";
      };
    };
  };

  programs.gpg = {
    enable = true;
  };

  services = lib.optionalAttrs sysconfig.graphical {
      gpg-agent = {
      enable = true;
      enableSshSupport = true;
      maxCacheTtl = 3600 * 24;
      maxCacheTtlSsh = 3600 * 24;
      extraConfig = "allow-preset-passphrase";
      pinentry.package = if sysconfig.graphical then pkgs.pinentry-gnome3 else pkgs.pinentry-tty;
    };
  };
}

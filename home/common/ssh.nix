{
  pkgs,
  sysconfig,
  lib,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*".UseRoaming = "no";
      "github.com".IdentityFile = "~/.ssh/github_rsa";
      "home.madsmogensen.dk" = {
        IdentityFile = "~/.ssh/server_rsa";
        Port = 2222;
      };
      "server-mads.lan" = {
        IdentityFile = "~/.ssh/server_rsa";
      };
      "desktop-mads.router.lan" = {
        IdentityFile = "~/.ssh/desktop_rsa";
      };
      "digitalocean 142.93.101.55" = {
        IdentityFile = "~/.ssh/digitalocean_ed25519";
        User = "root";
        Hostname = "142.93.101.55";
      };
    };
  };

  programs.gpg = {
    enable = true;
  };

  services = lib.optionalAttrs sysconfig.baremetal {
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

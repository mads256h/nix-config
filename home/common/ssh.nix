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
        IdentityFile = "~/.ssh/server_ed25519";
      };
      "server-mads.lan" = {
        IdentityFile = "~/.ssh/server_ed25519";
      };
      "desktop-mads.router.lan" = {
        IdentityFile = "~/.ssh/desktop_rsa";
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

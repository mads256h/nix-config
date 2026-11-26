{
  pkgs,
  sysconfig,
  ...
}:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        UseRoaming = "no";
        AddKeysToAgent = "yes";
        VerifyHostKeyDNS = "yes";
        KexAlgorithms = [
          "mlkem768x25519-sha256"
          "sntrup761x25519-sha512"
        ];
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
        ];
      };
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

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      maxCacheTtl = 3600 * 24;
      maxCacheTtlSsh = 3600 * 24;
      extraConfig = "allow-preset-passphrase";
      pinentry.package = if sysconfig.graphical then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
    };
  };
}

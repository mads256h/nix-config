{
  lib,
  pkgs,
  config,
  ...
}:
let
  strongModuli =
    pkgs.runCommand "moduli-strong-initrd"
      {
        nativeBuildInputs = [ pkgs.gawk ];
      }
      ''
        awk '$5 >= 3071' ${config.services.openssh.package}/etc/ssh/moduli > $out
      '';
in
{
  boot.kernelParams = [ "ip=dhcp" ];

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 22;
      authorizedKeys = config.users.users.mads.openssh.authorizedKeys.keys;
      hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];

      extraConfig = ''
        PermitRootLogin prohibit-password
        PasswordAuthentication no
        KbdInteractiveAuthentication no
        KexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org
        Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com
        Macs hmac-sha2-512-etm@openssh.com
        HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com
        ModuliFile ${strongModuli}
        LogLevel VERBOSE
      '';
    };

    postCommands = lib.optionalString (config.boot.initrd.luks.devices != { }) ''
      echo "cryptsetup-askpass" >> /root/.profile
    '';
  };
}

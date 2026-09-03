{
  lib,
  config,
  ...
}:
let
  lanDevName = "enp1s0";
in
{
  boot.initrd.systemd = {
    enable = true;
    network = {
      enable = true;
      networks."${lanDevName}" = config.systemd.network.networks.${lanDevName};
    };
  };

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      authorizedKeys = config.users.users.mads.openssh.authorizedKeys.keys;
      hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
    };

    postCommands = lib.optionalString (config.boot.initrd.luks.devices != { }) ''
      echo "cryptsetup-askpass" >> /root/.profile
    '';
  };
}

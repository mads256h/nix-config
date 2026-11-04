{
  config,
  ...
}:
let
  lanDevName = "enp3s0";
in
{
  boot.initrd.systemd.network = {
    enable = true;
    networks."${lanDevName}" = config.systemd.network.networks.${lanDevName};
  };

  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      authorizedKeys = config.users.users.mads.openssh.authorizedKeys.keys;
      hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
    };
  };

  boot.initrd.availableKernelModules = [ "igb" ];
}

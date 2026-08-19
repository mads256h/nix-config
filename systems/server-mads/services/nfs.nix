{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.nfs.server = {
    enable = true;
    exports = ''
      /export/share  10.0.1.220(ro,insecure)
      /export/share  10.0.1.0/24(rw)
    '';
    createMountPoints = true;
  };

  # Keep things inside the export directory
  fileSystems."/export/share" = {
    device = "/mnt/share";
    options = [ "bind" ];
    fsType = "none";
  };

  # rpcbind
  services.rpcbind.enable = true;

  # Allow through firewall
  networking.firewall = {
    allowedTCPPorts = [
      111
      2049
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      20048
    ];
  };
}

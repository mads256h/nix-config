# NFSv4
{
  ...
}:
let
  localNetwork = "10.0.1.0/24";
  tv = "10.0.1.220";
in
{
  services.nfs.server = {
    enable = true;
    # Fixed ports for firewall

    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;

    exports = {
      "/export/share" = {
        "${tv}" = [
          "ro"
          "all_squash"
          "insecure"
        ];

        "${localNetwork}" = [ "rw" ];
      };

      "/export/torrents" = {
        "${localNetwork}" = [
          "ro"
          "all_squash"
          "insecure"
        ];
      };
    };
    createMountPoints = true;
  };


  # Keep things inside the export directory
  fileSystems."/export/share" = {
    device = "/mnt/share";
    options = [ "bind" ];
    fsType = "none";
  };

  # Keep things inside the export directory
  fileSystems."/export/torrents" = {
    device = "/mnt/torrents";
    options = [
      "bind"
      "ro"
    ];
    fsType = "none";
  };

  # Allow through firewall
  networking.firewall = {
    allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
    allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
  };
}

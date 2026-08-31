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

  # Enforce v4 only
  services.nfs.settings.nfsd = {
    vers3 = false;
    vers4 = true;
    "vers4.0" = false;
    "vers4.1" = false;
    "vers4.2" = true;
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
  networking.firewall.allowedTCPPorts = [ 2049 ];
}

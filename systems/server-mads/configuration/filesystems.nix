{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/258ba2f6-9932-47e3-9b34-e11cc747e127";
    fsType = "btrfs";
    options = [
      "defaults"
      "space_cache=v2"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = [
      "defaults"
      "fmask=0177"
      "dmask=0077"
      "noexec"
      "nodev"
      "nosuid"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/cfb6f323-2397-4508-8f65-e6ac4e3aeea4"; }
  ];

  # Huuuuge tmpfs for building big packages
  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "256g";
  };

  # Share
  fileSystems."/mnt/share" = {
    device = "zpool";
    fsType = "zfs";
    options = [
      "defaults"
      "nodev"
      "nosuid"
      "zfsutil"
    ];
  };

  # Torrents
  fileSystems."/mnt/torrents" = {
    device = "/dev/disk/by-uuid/804fe9f8-1d31-4af9-9f7f-bd8fa9df42f5";
    fsType = "ext4";
    options = [
      "defaults"
      "nodev"
      "nosuid"
      "noexec"
      "noatime"
    ];
  };

  # Data
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/acb26053-df19-42f5-90b7-9e29079db53c";
    fsType = "ext4";
    options = [
      "defaults"
      "nodev"
      "nosuid"
      "errors=remount-ro"
    ];
  };

  services.btrfs.autoScrub.enable = true;

  services.zfs = {
    autoScrub.enable = true;
    autoSnapshot = {
      enable = true;
      # Default flags but with utc
      flags = "-k -p --utc";
    };

    zed = {
      enableMail = true;
      settings = {
        ZED_EMAIL_ADDR = "mads256h" + "@" + "pro" + "to" + "nmail" + ".com";
        ZED_NOTIFY_VERBOSE = true;
      };
    };
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    DEVICE partitions
    ARRAY /dev/md/torrents metadata=1.2 UUID=0091a52e:70a459d2:25d515d3:31cf5a8c
    MAILADDR ${"mads" + "256" + "h" + "@pro" + "tonm" + "ail" + ".com"}
  '';
}

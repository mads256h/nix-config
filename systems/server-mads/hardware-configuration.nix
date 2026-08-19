{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.kernelPackages = latestKernelPackage;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/258ba2f6-9932-47e3-9b34-e11cc747e127";
    fsType = "btrfs";
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
    device = "/dev/disk/by-uuid/51a551fa-d1ba-4c83-8ad5-bfcab4496f29";
    fsType = "btrfs";
    options = [
      "defaults"
      "nodev"
      "nosuid"
      "noexec"
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

  networking.hostId = "8f846d4c";

  services.btrfs.autoScrub.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

{ pkgs, config, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ../../configuration/common
    ../../configuration/graphical
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "max";

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.preLVMCommands = ''${pkgs.kbd}/bin/setleds +num '';

  networking.hostName = "desktop-mads"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  networking.firewall.enable = false;

  # Temporary fix
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}

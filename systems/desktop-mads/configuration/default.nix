{ pkgs, config, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ../hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "max";

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "desktop-mads"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  networking.firewall.enable = false;

  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    applications = {
      apps = [
        {
          name = "Steam Big Picture";
          prep-cmd = [
            {
              do = "${pkgs.bash}/bin/bash -lc '${pkgs.hyprland}/bin/hyprctl output create headless sunshine || true'";
              undo = "${pkgs.bash}/bin/bash -lc '${pkgs.hyprland}/bin/hyprctl output remove sunshine || true'";
            }
          ];
          detached = [
            "${pkgs.util-linux}/bin/setsid ${config.programs.steam.package}/bin/steam steam://open/bigpicture"
          ];
          "auto-detach" = "true";
        }
      ];
    };
  };
}

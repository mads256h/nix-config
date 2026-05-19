{ pkgs, config, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ../../configuration/common
    ./hardware-configuration.nix
    ./services/all.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "max";

  # Allow serving as a router. Useful for wireguard.
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # TODO: Enable lanzaboote
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "server-mads";
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  environment.systemPackages = with pkgs; [
    wireguard-tools
    hdparm
    smartmontools
  ];

  services.minecraft-server = {
    enable = true;
    eula = true;
    dataDir = "/mnt/data/minecraft-aau";
    openFirewall = true;
  };

  # Automatically download new youtube videos daily
  # TODO: This stops downloading if any errors occur in the for loop, we should keep going.
  systemd.services."update-yt" = {
    serviceConfig = {
      Type = "oneshot";
      User = "mads";
    };
    path = with pkgs; [ yt-dlp ];
    script = ''
      cd "/mnt/share/Mads/Videoklip/yt/"
      for D in */; do
        pushd "''${D}"
        echo "Updating ''${D%/}..."

        if [ -f "download.txt" ]; then
          cat "download.txt" | xargs yt-dlp -f bestvideo+bestaudio --add-metadata --embed-subs --all-subs --download-archive .archive -i
        else
          echo "No download.txt found in ''${D} skipping..."
        fi
        popd
      done
      exit 0
    '';
  };

  systemd.timers."update-yt" = {
    wantedBy = [ "timers.target" ];
    partOf = [ "update-yt.service" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "update-yt.service";
    };
  };
}

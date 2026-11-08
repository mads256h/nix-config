{ ... }:
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";

  };

  # Torrent disks are somehow not initialized right without this.
  boot.loader.timeout = 60;

  boot.loader.efi.canTouchEfiVariables = true;

  # TODO: Enable lanzaboote
  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };
}

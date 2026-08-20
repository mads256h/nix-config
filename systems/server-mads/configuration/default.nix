{ ... }:
{
  imports = [
    ../../../configuration/common
    ./services
    ./bootloader.nix
    ./filesystems.nix
    ./hardware.nix
    ./kernel.nix
    ./networking.nix
    ./packages.nix
  ];
}

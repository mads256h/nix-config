{ ... }:
{
  imports = [
    ./services
    ./bootloader.nix
    ./filesystems.nix
    ./hardware.nix
    ./initrd-ssh.nix
    ./kernel.nix
    ./networking.nix
    ./packages.nix
  ];
}

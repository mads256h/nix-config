{ ... }:
{
  imports = [
    ../../configuration/common
    ../../configuration/wsl
  ];

  # Allow vs code server to run
  programs.nix-ld.enable = true;
}

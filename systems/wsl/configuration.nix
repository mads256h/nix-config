{ ... }:
{
  imports = [
    ../../configuration/common
  ];

  # Allow vs code server to run
  programs.nix-ld.enable = true;
}

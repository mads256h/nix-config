{ ... }:
{
  nix.settings = {
    substituters = [
      "https://mads256h.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://hyprland.cachix.org"
    ];
    trusted-substituters = [
      "https://mads256h.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "mads256h.cachix.org-1:6kAAfDlu6DSFqADoOQzlkOPQKO1hoptBHgnJGnuEnkI="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}

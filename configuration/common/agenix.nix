{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.agenix.overlays.default ];

  environment.systemPackages = [ pkgs.agenix ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/root/agenix-pq-key"
  ];
}

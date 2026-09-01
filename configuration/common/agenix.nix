{ inputs, pkgs, ... }:
{
  environment.systemPackages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/root/agenix-pq-key"
  ];
}

# vim: ts=2 sw=2 et
{ config, lib, pkgs, ... }:

{
  services.nginx = {
    enable = true;

    # recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Allow your_spotify to import json files
    clientMaxBodySize = "500M";

    virtualHosts."home.madsmogensen.dk" =  {
      enableACME = true;
      forceSSL = true;
    };

    virtualHosts."file.madsmogensen.dk" = {
      enableACME = true;
      forceSSL = true;
      root = "/mnt/data/file.madsmogensen.dk/www";
    };

    virtualHosts."spotify.madsmogensen.dk" = {
      enableACME = true;
      forceSSL = true;
    };

    virtualHosts."webdav.madsmogensen.dk" =  {
      enableACME = true;
      forceSSL = true;
    };

    virtualHosts."server-mads.lan" =  {
      # Only allow local connections to this virtual host
      extraConfig =
          "allow 10.0.1.0/24;" +
          "deny all;"
          ;
    };

    virtualHosts."localhost" = {
      extraConfig =
        "allow 127.0.0.1;" +
        "allow ::1;" +
        "deny all;"
        ;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "mail@madsmogensen.dk";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

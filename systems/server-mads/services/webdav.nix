# vim: ts=2 sw=2 et
{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.nginx.virtualHosts."webdav.madsmogensen.dk".locations."/" = {
    root = "/mnt/share";
    basicAuthFile = "/mnt/data/webdav/htpasswd";
    extraConfig = ''
      autoindex on;

      dav_methods PUT DELETE MKCOL COPY MOVE;
      create_full_put_path on;
      dav_access user:rw group:rw all:r;

      sendfile on;
      aio threads;
      directio 8m;
      output_buffers 1 1m;
    '';
  };
}

{
  config,
  pkgs,
  lib,
  inputs,
  stylix,
  ...
}:
{
  accounts.calendar.accounts.personal = {
    primary = true;

    thunderbird.enable = true;

    remote = {
      url = "https://home.madsmogensen.dk/radicale/mads/fb051b6c-81f2-4e78-b5dc-65a0a0a4361f/";
      userName = "mads";
      passwordCommand = ''
        ${pkgs.libsecret}/bin/secret-tool lookup caldav password
      '';
      type = "caldav";
    };
  };

  accounts.contact.accounts.personal = {
    thunderbird.enable = true;

    remote = {
      url = "https://home.madsmogensen.dk/radicale/mads/a8aebf57-1221-4bfd-4afe-ca5767489a90/";
      userName = "mads";
      passwordCommand = ''
        ${pkgs.libsecret}/bin/secret-tool lookup caldav password
      '';
      type = "carddav";
    };
  };

  accounts.email.accounts.protonmail = {
    primary = true;

    thunderbird.enable = true;

    realName = "Mads Mogensen";
    address = "mads256h@protonmail.com";
    userName = "mads256h@protonmail.com";

    aliases = [
      "mail@madsmogensen.dk"
    ];

    imap = {
      host = "127.0.0.1";
      port = 1143;
      tls = {
        enable = true;
        useStartTls = true;
        certificatesFile = "${config.xdg.configHome}/.certs/cert.pem";
      };
    };

    smtp = {
      host = "127.0.0.1";
      port = 1025;
      tls = {
        enable = true;
        useStartTls = true;
        certificatesFile = "${config.xdg.configHome}/.certs/cert.pem";
      };
    };
  };
}

{ config, ... }:
{
  age.secrets = {
    sendmail-password = {
      file = ../../../../secrets/sendmail-password.age;
      owner = "root";
      group = "root";
      mode = "444";
    };
  };

  programs.msmtp = {
    enable = true;
    accounts.default = {
      auth = true;
      tls = true;

      host = "smtp.gmail.com";
      port = 587;
      from = config.programs.msmtp.accounts.default.user;
      user = "mads256h" + "@" + "gm" + "ail" + ".com";
      passwordeval = "cat ${config.age.secrets.sendmail-password.path}";
    };
  };
}

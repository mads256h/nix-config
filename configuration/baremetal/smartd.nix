{ sysconfig, ... }:
{
  services.smartd = {
    enable = true;

    notifications.mail.recipient = "mads256h" + "@pro" + "to" + "nmail" + ".com";
    notifications.systembus-notify.enable = sysconfig.graphical;
  };
}

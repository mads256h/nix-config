{ sysconfig, ... }:
{
  services.smartd = {
    enable = true;

    # TODO: Remove this when confirmed working
    notifications.test = true;

    notifications.mail.recipient = "mads256h" + "@pro" + "to" + "nmail" + ".com";
    notifications.systembus-notify.enable = sysconfig.graphical;
  };
}

{ pkgs, ... }:
{
  # Enable numlock early on boot
  boot.initrd.systemd.storePaths = [
    "${pkgs.kbd}/bin/setleds"
  ];

  boot.initrd.systemd.services.enable-numlock = {
    description = "Enable numlock";
    wantedBy = [ "initrd.target" ];
    before = [ "initrd-root-device.target" ];
    unitConfig = {
      DefaultDependencies = false;
    };

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kbd}/bin/setleds -D +num";
      StandardInput = "tty";
      TTYPath = "/dev/tty0";
    };
  };

  # keychron hardware
  hardware.keyboard.qmk = {
    enable = true;
    keychronSupport = true;
  };

  # Swap capslock with esc
  services.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };
}

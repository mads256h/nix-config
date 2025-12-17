{ pkgs, inputs, ... }:
{
  fonts.packages = with pkgs; [
    font-awesome
    corefonts
    vista-fonts
  ];

  environment.systemPackages = [
    inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.steam = {
    enable = true;
    extest.enable = true;
    protontricks.enable = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings.general.renice = 10;
  };
  users.users.mads.extraGroups = [ "gamemode" ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    configPackages = [ inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland ];
    xdgOpenUsePortal = true;
  };

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # spotify
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];

  networking.networkmanager.dispatcherScripts = [
    {
      type = "pre-down";
      source = "${pkgs.writeShellScript "lock-keepassxc-database" ''
        set -e

        echo $2

        SOCKET_NAME="/tmp/keepassxc-mads.socket"

        # Prepare data to be sent
        # Format:
        # [block_size (4 bytes)][ID (4 bytes)][data_size (4 bytes)]
        # The lock signal is an ID of '2' (quint32) and we will reserve the space for block size
        BLOCK_SIZE=12 # 4 (block size) + 4 (ID) + 4 (size)
        LOCK_SIGNAL=2  # This is the ID for database lock as per your source code

        # Prepare the data for the lock signal
        DATA="\x00\x00\x00\x00" # Placeholder for block size (we'll update this later)
        DATA+="\x00\x00\x00\x02" # Lock signal ID (quint32: 2)
        DATA+="\x00\x00\x00\x0C" # Block size (12 bytes)

        # Now we need to send this to the socket
        echo -n -e "$DATA" | ${pkgs.socat}/bin/socat - UNIX-CONNECT:"$SOCKET_NAME"

        # Check if the connection was successful
        if [ $? -eq 0 ]; then
            echo "Database lock signal sent successfully."
        else
            echo "Failed to send lock signal."
            exit 1
        fi

        sleep 2

        systemctl stop home-mads-mnt.mount
      ''}";
    }
  ];

  services.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  services.libinput.enable = true;

  security.polkit.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.pam.services.login.gnupg = {
    enable = true;
    storeOnly = true;
    noAutostart = true;
  };

  security.pam.services.hyprlock.gnupg = {
    enable = true;
    noAutostart = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.hyprlock.enableGnomeKeyring = true;

  fileSystems =
    let
      # Use the user's gpg-agent session to query
      # for the password of the SSH key when auto-mounting.
      sshAsUser = pkgs.writeScript "sshAsUser" ''
        user="$1"; shift
        exec ${pkgs.sudo}/bin/sudo -i -u "$user" \
          ${pkgs.openssh}/bin/ssh "$@"
      '';
      options = [
        "user"
        "uid=mads"
        "gid=users"
        "allow_other"
        "nosuid"
        "noexec"
        "nodev"
        "_netdev"
        "ssh_command=${sshAsUser}\\040mads"
        "noauto"
        "comment=x-gvfs-show"
        "x-gvfs-name=server"
        "x-gvfs-icon=network-server"
        "x-gvfs-symbolic-icon=network-server"
        "x-systemd.automount"
        #"Compression=yes" # YMMV
        # Disconnect approximately 2*15=30 seconds after a network failure
        "reconnect"
      ];
    in
    {
      "/home/mads/mnt" = {
        device = "${pkgs.sshfs-fuse}/bin/sshfs#mads@home.madsmogensen.dk:/mnt/share";
        fsType = "fuse";
        inherit options;
      };
    };
}

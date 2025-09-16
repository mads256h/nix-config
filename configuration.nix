# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "max";

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.preLVMCommands = '' ${pkgs.kbd}/bin/setleds +num '';

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "laptop-mads"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "da_DK.UTF-8";
  console = {
  #   font = "Lat2-Terminus16";
     keyMap = "dk";
  #   useXkbConfig = true; # use xkb.options in tty.
  };

  nixpkgs.overlays = [ 
    (import ./overlays/st-custom)
    (import ./overlays/packages)
  ];


  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mads = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  fonts.packages = with pkgs; [
    font-awesome
    font-awesome_6
  ];

  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";
    fonts.sizes.applications = 10;
    fonts.sizes.terminal = 11;
    fonts.serif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    fonts.sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    fonts.monospace = {
      package = pkgs.nerd-fonts.hack;
      name = "Hack Nerd Font";
    };
    fonts.emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "Breeze";
      size = 32;
    };
  };

  security.polkit.enable = true;

  programs.steam = {
    enable = true;
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    wget
    curl
    htop
    lshw
    pciutils
    killall
    spotify
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    sbctl
    st
  ];

  # spotify
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];

  hardware.graphics.enable = true;

  services.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  security.pam.services.login.gnupg = {
    enable = true;
    storeOnly = true;
    noAutostart = true;
  };

  security.pam.services.hyprlock.gnupg = {
    enable = true;
    noAutostart = true;
  };

  fileSystems =
    let
      # Use the user's gpg-agent session to query
      # for the password of the SSH key when auto-mounting.
      sshAsUser =
        pkgs.writeScript "sshAsUser" ''
          user="$1"; shift
          exec ${pkgs.sudo}/bin/sudo -i -u "$user" \
            ${pkgs.openssh}/bin/ssh "$@"
        '';
      options =
        [
          "user"
          "uid=mads"
          "gid=users"
          "allow_other"
          "nosuid"
          "_netdev"
          "ssh_command=${sshAsUser}\\040mads"
          "noauto"
          "x-gvfs-hide"
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
  #systemd.automounts = [
    #{ where = "/mnt/aubergine"; automountConfig.TimeoutIdleSec = "5 min"; }
  #];

  nix.settings.experimental-features = ["nix-command" "flakes" ];
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}


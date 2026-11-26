{
  pkgs,
  inputs,
  sysconfig,
  config,
  lib,
  ...
}:
{
  imports = [
    ./agenix.nix
    ./cachix.nix
    ./hardening.nix
    ./ssh.nix
    ./stylix.nix
  ]
  ++ lib.optional sysconfig.baremetal ../baremetal
  ++ lib.optional sysconfig.graphical ../graphical
  ++ lib.optional sysconfig.laptop ../laptop
  ++ lib.optional sysconfig.server ../server
  ++ lib.optional sysconfig.wsl ../wsl;

  age.secrets = {
    user-mads-password.file = ../../secrets/user-mads-password.age;
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "da_DK.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    keyMap = "dk";
    #   useXkbConfig = true; # use xkb.options in tty.
  };
  users.mutableUsers = false;

  users.users.mads = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

    hashedPasswordFile = config.age.secrets.user-mads-password.path;
  };

  # Only allow people from the wheel group to even execute sudo
  security.sudo.execWheelOnly = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    wget
    curl
    killall
    sbctl
    hdparm
  ];

  services.fstrim.enable = sysconfig.baremetal;


  services.fwupd.enable = sysconfig.baremetal;

  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import ../../overlays/packages)
    # Disable aws support in nix
    (final: prev: {
      nix = prev.nix.overrideScope (
        finalScope: prevScope: {
          nix-store = prevScope.nix-store.override {
            withAWS = false;
          };
        }
      );

      nixVersions = prev.nixVersions // {
        latest = prev.nixVersions.latest.overrideScope (
          finalScope: prevScope: {
            nix-store = prevScope.nix-store.override {
              withAWS = false;
            };
          }
        );
      };
    })
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
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
  system.stateVersion = "26.05"; # Did you read the comment?
}

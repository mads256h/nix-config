{
  pkgs,
  inputs,
  sysconfig,
  config,
  lib,
  ...
}:
let
  strongModuli =
    pkgs.runCommand "moduli-strong"
      {
        nativeBuildInputs = [ pkgs.gawk ];
      }
      ''
        awk '$5 >= 3071' ${config.services.openssh.package}/etc/ssh/moduli > $out
      '';
in
{
  imports = [
    ./agenix.nix
    ./cachix.nix
    ./hardening.nix
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

    openssh.authorizedKeys.keys = [
      # desktop-mads: server_mldsa44-ed25519
      "ssh-mldsa44-ed25519 AAAAE3NzaC1tbGRzYTQ0LWVkMjU1MTkAAAVARMFrI38No7674+IMCFpL9UwYGn3nOtiBpcllmLPV/oHtDhmkKztJXbgCC6ckigS7KlgjKf4iBVKn8enl/W5e2lw3GO2dd4bWK99hNJqlknWVHc4eD6EgptYblPX8KrZA0RVybWffrEU4C9rRQfT+zvDBKRfzGgZG+qJWgqBVkpIHZu8fdPhZZ9ORQXAI8hP6JcTmhUiP6NsOooFRH/xXDQPhg+YPNWWvD7k7mlbSvrjzpLL7DeEkVojMC8WQjSF2vD84APdHKh+YRfPmr7UcHJ4IwdI9QJ9SFoOW0Vjnq3lbM2YuqNsx2Ec+kaxGuRJj9a7hhH9xeWNOJkm6msDXSL9w1hVn0S6JoMDaXasNOjHAAprQf5CzKreaChtM9iQloM1rf8GVp/Xlv6mEOLft5VpUll0rcDSSH0JdKesLnr8lwklA9trZeCJ6XUx/cX2xqojdQZJG2Bmkf9uUelw0+FNc6OQVCVM4v/gaKGbmFgxJ+T5+18xRYN82l0PyeiF/G7RQUycFNpKf+d+XczybpSxSwgZQwZ3I5uRLc/vzP2tRoFZ3DSjoQR8AE5QVtBX2YrZsXmxnVrlPsWUjmQxEDT3Cm5Z5eQKBs3Gp9me1rdH//i95bmUxUbMVyzzP4qxI8RKLZPO8RWC+ZuqkqHPAK70InBKNfKJal25D83ftW2diuexISZbQMKlzajGJBpOYYEhk9W3ljdYAsmoTv3kYPu1yXdKaBpdQC1/71RDD+xfGwsA9KrqTkvN8QlySFfkaCsSJXanmzgvdeEbXbjVQYyyK/6yp5G3J1e/Bg6gEj2cGmbslIlSEktcE1Q2tbM4fvUOwquyNljroXJR/eQYwT5WD58haPOyrTTVOhU+SirwyW+O3CsHJ6Qe2T3B0siOBkRgttS/GC4UaZe0srgY4jTSg10Ff97KHFh+x1VUVjuhk1Ew6LbGN3hv88+MJuLhonzF3a7B98i+2v5pw/WcHvsIxpkuqhxAdpy0acdvp6c8p1PCh9gtwPgivixSen3Pc5rNH4lcHl5z7UadKwOg3HmaDML7J47FVDChOmGVXnFNLGQP49jkRRJzAQPDMb0+Z4kIrxY9ixVsFiFi2en9q8JnUh9VAhiMINKlvhndZBlLCHfocINMEJnmFE/qD8L/4JjbbPBHgHORz+wOzNkLeXWvr05AIFYqK2aBLhQ+NtB3Uf8e5uEwWJ+kYeKTawV7951zN4HXrLGQnbM+tiHyCDZVj40UoAHfQrim6GBb9LipdBLfj5xnvImYy6hVtINREz+liBbi5YZ8dssg98IDHJefxPtR3js3YH9TQ1eNGg2vOygzQUBJQxxbWTp+8WisEdOCS1lE8Xg93HXraTIIn8LTBF+mZpcjOrKljOJiPQug+uV5J9X4Hrye0glXi7tHQwca2XhgQg8ujdZgq1VDqOxP5+t7Nf6Jut3ZvpLGbfdzJLI3hqIe6XALZ4VC44mtGnNKL9A3hcfJe8hMiijDSc+2RKuMMQymVBhTQEh1XEQ9R4ASeLt3RsYTPColxuBL4Ks68QWxGJMCixaqMBoLzedGfHq3WRCenx5DOgs4utUIcz632WswUbZdZHogV9BcoBf8dUQT0TiM7fnz5NVJbsGI54dP98kLCeIvQz2ysuMIXkvo0sJ97mrPG6ugA31OdnSqzbigppBfejWcuM/H0Tp4N382YcQxS1tuQec6+IOz48GVsMUoAHNttK5fopNJqkLb6OJAgKmSYznZuwuevk/Tne+bRIB+E/QgMij1rGK/RK9i1cJ/QQiT5muFubmOK mads@desktop-mads"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+dpaPAPx8PiwvhUSKmVf1IGWpFcGGNP3suSaxgy+Cxd0EuqpSZekFbO9RliGHt/yE9/u1MeNjntvwfO95bEIYkq9n12jiGKTdG+Qt6SI7IesE/UrPK/yHe2QogjAaUU6I5rAigCIM9Q7FYosU0nsWWQMjdkbyQ0OtquT3Me5NXOWhFWXRZr/molgO3EQKI4ElSUDlWgp9fJLALGE+3Jp88coPnp+yfxI2UqMY6VyranYBaiIbKv27YlaqMkhh21DNYh+smQCoz4DuSNEZiqrmLFGZoqBEO5qptu+HfIRsLwtBAKYu5s2ucZmjlF54BoRwfzDvAMuvZs6o2AB+TDBw+OANUBH4SLiD/9oBOyvCeNzFQuUViElCBI+QGbdgtXUWc6gwmMYX0lxfbIgcnmkeQL0GL4floawXWg48hvKMhuEvW8WimTHiZBi8f1ZxYaTs57BLmdEynvOSwi2ODhGMjT1au11bo5O2s9AtfQfgl57br7FSgsCzBMstcNsS3S/NcngYA5VXVwPBR1KyJVFicxcGbHRf0fbfdI1GQWgAV2fbxGmDDrqW7IH6w4SAR+6bYqNOEv51ijVvNXU9cBJQ5qlH7hj7TJpEWn5UR7LdTm96lCsaa5AICOlfkXppiOq8qRACkd1TqcT9Dq30fzuFND3Xghg8cuZ9P6zv700uyQ== mads@laptop-mads"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCPwWRU4SBf36Xb2e5RtwjmsiIHep0lMi0OAqOVA748RgRfP7ZDJ8boj0LF+1VAyU17Ht8Lo1kVKoYx38sMiQlgP2vbEV7NXpyikBdqmAEtCpBWEWJsh04FrPpwyCgdA+rCypjQ8Qw9FhtI0yIppXv2RRCi9MkXZeM5X1/oY7ajpQ4doSJtF1hxyv6npJr7jJkbWO2l6fASqu/tyY3BNdk4sSaPbcUCpYAEqci/FDLlyrlxWE1+TijC08YzctUPeeaBSIMpuf3VVaTgp69FI0IoLvt7Bb34kxLvOvQijSaVBQqRrg9GXk3l1JeEdCQNDJwqd08MP35dAAPbaOpnsgY66kSGwmyDp64J+XLPT+KWG/yHoyvuNpQStNm5/KdmGv6ZAhGWMTvCKwvp6tqHdS8UGJ7fDvHjnALhJ5skT+jb2l//vDlDkPg6lDMB0P+ILqm3M3o8A71EglW6VI8lboxknID4YP6BwE2Xe/cRwRnJs9eNMErMT2wtYv758uQaoqyYJwiNnvvvJqjBZypq4JYKiMlJbvyaDZXXax6qACfsD2FSxUnN/lONASmIh04TNk6PS1WX+HrvnUlBNKB9ou2wkQCFro729OftPqwMLTBBuJ5xI8ZYuDvGi9lT0htrGnSBmO204TVktrPWaCqszv7YpmLnodUGzSJJxA5g3ZaywQ== mads@nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHXyHXxD1lS3XUH5+uTJUzj+WPZXqZh9+G7tYUS0KzU1 mads@nixos"
    ];

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

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_mldsa44-ed25519_key";
        type = "mldsa44-ed25519";
      }
    ];
    settings = {
      # Hardening options
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      # Restrict algorithms to only very secure ones
      KexAlgorithms = [
        "mlkem768x25519-sha256"
        "sntrup761x25519-sha512"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
      ];
      HostKeyAlgorithms = "ssh-mldsa44-ed25519";

      ModuliFile = "${strongModuli}";

      # Log user fingerprints for audit purposes
      LogLevel = "VERBOSE";
    };
  };

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

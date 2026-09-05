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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCeCSo+ztID41jlKZIy++UdhacKy0I4A/qqCWBBU1RP1NnoKdMcFqXyKJFLsltpuTuWKf9WnTgT+KCidMR8Foysdic5i7lGy4TMP8sa+RqNVUhLM93fM7YHrmGZHVbrg0rNVKnbFv/0lDZLiyp/l7B7vmuBtE3pCYW7nbFvoje+5pWDrpFL16qAFgIM5i3Ly9adkkObVw1Nz4tkjS5i6AJQc5ZYFzipVl5XU9NHdxg2SQrXokeX59AEN0UaUuUm/Ft0Mxyu01MyuHcqLK/b2netJrF/THj4bYu629IqDe+FT+APihhlvp40WI8Py9/dl6OSzB35XaQ1X60WBfqgLFgu6vM3NgItzVjRjb72paJ6YdVkhMJZezMdJxKfxrLXJPTLQELhETB0mFtM4tMb2Mh43Jp3oWPLg9ZtFEcKlafAWuHpbRHRsjD58UawrB3M/uq8+T+jmlh9CSRdcjIlf+Oz1AANk2rU/voUE8jhzeRLOwLNEahAb1d5mBLklOK9351gzRmYJxPuggdR0EiRchE59JiSUAmGxky0bHyOfOoqdLkd5cIxmv8FTqY2BXvHJhe8DpWaxYt/rR9ckTiNyJ+XgkvpGMDbwpoJBh1ELmZ2Iy3mg/r2Gmw83eK4w+q+Wzz3Nhm8flVikL+DAwPnfV8dObzyC62LNTWos1Gb+lY7Aw== mads@DESKTOP-MADS"
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
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    settings = {
      # Hardening options
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      # Restrict algorithms to only very secure ones
      KexAlgorithms = [
        "sntrup761x25519-sha512@openssh.com"
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
      ];
      HostKeyAlgorithms = "ssh-ed25519,ssh-ed25519-cert-v01@openssh.com";

      ModuliFile = "${strongModuli}";

      # Log user fingerprints for audit purposes
      LogLevel = "VERBOSE";
    };
  };

  services.fwupd.enable = sysconfig.baremetal;

  hardware.enableRedistributableFirmware = true;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [ (import ../../overlays/packages) ];

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

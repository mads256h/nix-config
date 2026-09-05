{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/hyprland?ref=45c8510c9c52aee541ac2b31c2b716d61c526241";
    #hyprland.url = "github:hyprwm/hyprland?ref=v0.56.2";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    #hyprland-plugins.url = "github:hyprwm/hyprland-plugins?ref=v0.54.2";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    hy3.url = "github:outfoxxed/hy3?ref=hl0.56.0.1";
    hy3.inputs.hyprland.follows = "hyprland";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v1.1.0";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      home-manager,
      agenix,
      stylix,
      lanzaboote,
      nixos-wsl,
      hyprland,
      ...
    }:
    let
      makeSystem =
        hostname: sysconfig: extraModules:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            sysconfig = sysconfig;
          };

          modules = makeSystemModules hostname sysconfig extraModules;
        };

      makeSystemModules =
        hostname: sysconfig: extraModules:
        [
          (./systems + "/${hostname}/configuration")

          ./configuration/common

          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit inputs sysconfig;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mads = {
              imports = [
                (./systems + "/${hostname}/home.nix")
                agenix.homeManagerModules.default
              ];
            };
          }

          agenix.nixosModules.default

          stylix.nixosModules.stylix
        ]
        ++ extraModules;

      makeBaremetalSystem =
        hostname: sysconfig: extraModules:
        makeSystem hostname
          (
            {
              baremetal = true;
              wsl = false;
            }
            // sysconfig
          )
          (
            [
              ./modules/ci-vm.nix
              lanzaboote.nixosModules.lanzaboote
            ]
            ++ extraModules
          );

      makeBootTest =
        hostname: sysconfig: extraModules:
        let
          hostSysconfig = {
            baremetal = true;
            wsl = false;
          } // sysconfig;
          pkgs = import nixpkgs { system = "x86_64-linux"; };
        in
        pkgs.testers.runNixOSTest {
          name = "${hostname}-boot-test";
          nodes.machine = {
            lib,
            ...
          }: {
            _module.args = {
              inherit inputs;
              sysconfig = hostSysconfig;
            };
            imports =
              makeSystemModules hostname hostSysconfig (
                [
                  ./modules/ci-vm.nix
                  lanzaboote.nixosModules.lanzaboote
                ]
                ++ extraModules
                ++ [
                  {
                    systemd.services.ci-boot-success.enable = lib.mkForce false;
                  }
                ]
              );
          };
          testScript = ''
            start_all()
            machine.wait_for_unit("multi-user.target")
            machine.wait_until_succeeds("test -z \"$(systemctl list-units --failed --no-legend --plain)\"")

            ${nixpkgs.lib.optionalString sysconfig.graphical ''
              machine.wait_until_succeeds("find /run/user/*/hypr -maxdepth 2 -name hypr_loaded_ok | grep -q .")
              machine.succeed("su - mads -c 'export XDG_RUNTIME_DIR=/run/user/1000; export HYPRLAND_INSTANCE_SIGNATURE=$(${pkgs.coreutils}/bin/ls -1 /run/user/1000/hypr | ${pkgs.coreutils}/bin/head -n1); ${pkgs.hyprland}/bin/hyprctl dispatch exec \"sh -lc \\\"touch /tmp/hy3-exec-ok\\\"\"'")
              machine.wait_for_file("/tmp/hy3-exec-ok")
            ''}
          '';
        };
    in
    {
      nixosConfigurations."desktop-mads" =
        makeBaremetalSystem "desktop-mads"
          {
            graphical = true;
            laptop = false;
            server = false;
          }
          [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
          ];

      nixosConfigurations."laptop-mads" =
        makeBaremetalSystem "laptop-mads"
          {
            graphical = true;
            laptop = true;
            server = false;
          }
          [
            nixos-hardware.nixosModules.msi-gl62
          ];

      nixosConfigurations."wsl" =
        makeSystem "wsl"
          {
            baremetal = false;
            graphical = false;
            laptop = true;
            server = false;
            wsl = true;
          }
          [
            nixos-wsl.nixosModules.default
          ];

      nixosConfigurations."server-mads" =
        makeBaremetalSystem "server-mads"
          {
            graphical = false;
            laptop = false;
            server = true;
          }
          [
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc-ssd
          ];

      checks.x86_64-linux = {
        desktop-mads-boot-test = makeBootTest "desktop-mads"
          {
            graphical = true;
            laptop = false;
            server = false;
          }
          [
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
            nixos-hardware.nixosModules.common-pc-ssd
          ];

        laptop-mads-boot-test = makeBootTest "laptop-mads"
          {
            graphical = true;
            laptop = true;
            server = false;
          }
          [
            nixos-hardware.nixosModules.msi-gl62
          ];

        server-mads-boot-test = makeBootTest "server-mads"
          {
            graphical = false;
            laptop = false;
            server = true;
          }
          [
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-pc-ssd
          ];
      };
    };
}

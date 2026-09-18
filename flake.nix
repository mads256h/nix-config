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
      makeModules =
        hostname: sysconfig:
        [
          (./systems + "/${hostname}/configuration")

          ./configuration/common

          home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit sysconfig;
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
        ];

      makeSystem =
        hostname: sysconfig: extraModules:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            sysconfig = sysconfig;
          };

          modules = makeModules hostname sysconfig ++ extraModules;
        };

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

      mkVmBootTest =
        name: hostname: sysconfig: extraModules: graphical:
        let
          vmSysconfig =
            {
              baremetal = true;
              wsl = false;
            }
            // sysconfig;
        in
        nixpkgs.legacyPackages.x86_64-linux.testers.runNixOSTest {
          name = "${name}-vm-boot";
          node.pkgsReadOnly = false;
          node.specialArgs = {
            inherit inputs;
            sysconfig = vmSysconfig;
          };
          nodes.machine = { ... }: {
            imports =
              makeModules hostname vmSysconfig
              ++ [
                ./modules/ci-vm.nix
                lanzaboote.nixosModules.lanzaboote
              ]
              ++ extraModules
              ++ [
                { ciVm.applyToCurrentSystem = true; }
              ];
          };
          testScript =
            ''
              machine.start()
              machine.wait_for_console_text("CI_BOOT_OK")
              machine.wait_for_shutdown()

              console_log = machine.get_console_log()
              assert "CI_UNITS_FAILED" not in console_log, "One or more systemd units failed to start."
            ''
            + nixpkgs.lib.optionalString graphical ''
              assert "CI_HYPR_NOT_STARTED" not in console_log, "Hyprland never started."
              assert "CI_HYPR_ERRORS_FOUND" not in console_log, "Hyprland logged errors."
              assert "CI_HYPR_OK" in console_log, "Hyprland did not report success."
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
        desktop-mads-vm-boot =
          mkVmBootTest "desktop-mads" "desktop-mads"
            {
              graphical = true;
              laptop = false;
              server = false;
            }
            [
              nixos-hardware.nixosModules.common-cpu-amd
              nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
              nixos-hardware.nixosModules.common-pc-ssd
            ]
            true;

        laptop-mads-vm-boot =
          mkVmBootTest "laptop-mads" "laptop-mads"
            {
              graphical = true;
              laptop = true;
              server = false;
            }
            [
              nixos-hardware.nixosModules.msi-gl62
            ]
            true;

        server-mads-vm-boot =
          mkVmBootTest "server-mads" "server-mads"
            {
              graphical = false;
              laptop = false;
              server = true;
            }
            [
              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-pc-ssd
            ]
            false;
      };
    };
}

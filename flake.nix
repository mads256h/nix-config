{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/hyprland?ref=5fbb2a7acce2d6f155d18cf5b590fc553a8e7abc";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    hy3.url = "github:elafarge/hy3?ref=378fb240479d631bed749554417cf9d12e5e0ef6";
    #hy3.url = "github:outfoxxed/hy3?ref=12a73ab0adddbc39f839da320dcc2b028769fc58";
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
      nur,
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

          modules = [
            (./systems + "/${hostname}/configuration")

            ./configuration/common

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = specialArgs;
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

            nur.modules.nixos.default

            stylix.nixosModules.stylix
          ]
          ++ extraModules;
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
    };
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/hyprland";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";   
    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };
    hy3.url = "github:outfoxxed/hy3";
    hy3.inputs.hyprland.follows = "hyprland";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = inputs@{ self, nixpkgs, nixos-hardware, home-manager, stylix, lanzaboote, nixos-wsl, ... }: {
    nixosConfigurations."desktop-mads" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; sysconfig = { graphical = true; laptop = false; }; };
      modules = [
        ./systems/desktop-mads/configuration.nix
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        nixos-hardware.nixosModules.common-pc-ssd
        
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mads = ./systems/desktop-mads/home.nix;
        }

        stylix.nixosModules.stylix

        #lanzaboote.nixosModules.lanzaboote
      ];
    };

    nixosConfigurations."laptop-mads" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; sysconfig = { graphical = true; laptop = true; }; };
      modules = [
        ./systems/laptop-mads/configuration.nix
        nixos-hardware.nixosModules.msi-gl62
        
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mads = ./systems/laptop-mads/home.nix;
        }

        stylix.nixosModules.stylix

        lanzaboote.nixosModules.lanzaboote
      ];
    };

    nixosConfigurations."wsl" = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; sysconfig = { graphical = false; laptop = true; }; };
      modules = [
        ./systems/wsl/configuration.nix
        
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mads = ./systems/wsl/home.nix;
        }

        stylix.nixosModules.stylix

      nixos-wsl.nixosModules.default
      ];
    };
  };
}

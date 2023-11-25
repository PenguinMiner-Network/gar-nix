{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hardware.url = "github:NixOS/nixos-hardware";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = {
    self,
    nixpkgs,
    sops-nix,
    ...
  } @ inputs: let
    forEachSystem = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system:
        f {
          pkgs = import nixpkgs {inherit system;};
        });

    mkSystem = name: {
      class,
      modules ? [],
      ...
    }:
      nixpkgs.lib.nixosSystem ({
          specialArgs = {inherit inputs;};
        }
        // {
          modules =
            modules
            ++ [
              ({
                lib,
                config,
                ...
              }: {
                nix = {
                  registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

                  nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

                  settings = {
                    experimental-features = "nix-command flakes";
                    auto-optimise-store = true;
                  };
                };

                nixpkgs.config.allowUnfree = true;

                networking.hostName = lib.mkDefault name;
              })
              (./system + "/${name}")
              (sops-nix + "/modules/sops")
              (./common/system + "/${class}.nix")
            ];
        });

    systems = {
      whale = {
        class = "server";
      };
    };
  in {
    formatter = forEachSystem ({pkgs}: pkgs.alejandra);

    nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem systems;
  };
}

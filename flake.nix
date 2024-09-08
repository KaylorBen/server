{
  description = "NixOS flake for home-server (gaming)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    agenix.url = "github:ryantm/agenix";
  };

  outputs = { self, ... }@inputs:
  {
    nixosConfigurations.default = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = with inputs; [
        ./system
        # ./modules/impermanence
        disko.nixosModules.disko
        impermanence.nixosModules.impermanence
        agenix.nixosModules.default
      ];
    };
  };
}

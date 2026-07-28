{
  description = "NixOS Master Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    
    
    noctalia.url = "github:noctalia-dev/noctalia";
    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.default
        {
          home-manager.users.nixos-user = import ./home.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}

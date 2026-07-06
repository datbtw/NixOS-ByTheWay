{
  description = "NixOS Master Flake - Clean 2 Kernels Setup";

  inputs = {
    # Nhánh master đu đỉnh 26.11-pre của ông
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    
    # Kho kernel CachyOS chính chủ của pháp sư xddxdd nhánh master
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    
    noctalia.url = "github:noctalia-dev/noctalia";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # Bơm inputs xuống các file con (configuration.nix)
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

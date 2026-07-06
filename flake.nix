{
  description = "NixOS Master Flake - 3 Kernels Setup";

  inputs = {
    # Giữ nguyên nhánh master đu đỉnh 26.11-pre của ông
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    
    # Thay thế hoàn toàn chaotic bằng kho cachyos-kernel nhánh master của xddxdd
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
    
    noctalia.url = "github:noctalia-dev/noctalia";
    
    linux-next-src = {
      url = "path:/home/nixos-user/linux-next";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-cachyos-kernel, ... }@inputs: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # Quan trọng: Bơm inputs xuống các file con để configuration.nix bốc được 'nix-cachyos-kernel' và 'linux-next-src'
      specialArgs = { inherit inputs; };

      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        home-manager.nixosModules.default
        
        # Đã xóa bỏ dòng dòng chaotic.nixosModules.default ở đây 
        # Vì cấu hình mới ăn trực tiếp qua default overlay trong configuration.nix rồi
        {
          home-manager.users.nixos-user = import ./home.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}

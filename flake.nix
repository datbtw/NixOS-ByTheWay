{
  description = "NixOS Master Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    noctalia.url = "github:noctalia-dev/noctalia";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fcitx5-lotus = {
      url = "github:LotusInputMethod/fcitx5-lotus";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      # KHÔNG follows nixpkgs — giữ nixpkgs revision riêng mà repo này đã
      # pin sẵn để đảm bảo trúng binary cache, tránh phải build kernel từ
      # source (mất rất nhiều thời gian).
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
        inputs.fcitx5-lotus.nixosModules.fcitx5-lotus
        {
          home-manager.users.nixos-user = import ./home.nix;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
  };
}

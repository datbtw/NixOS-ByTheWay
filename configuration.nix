# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    # Kết quả hardware scan
    ./hardware-configuration.nix

    # Kernel (CachyOS + specialisation RC stock)
    ./kernel.nix

    # Bộ gõ fcitx5 (Lotus, bamboo, unilume)
    ./input-method.nix

    # Desktop environment / window managers / display manager
    ./desktop.nix

    # Bootloader + filesystem (btrfs)
    ./boot-fs.nix

    # Graphics / video / wayland env vars / bluetooth / power
    ./hardware-media.nix

    # System packages
    ./packages.nix
  ];

  nix = {
    settings = {
      cores = 12;
      sandbox = false;
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];

      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "26.05";

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Ho_Chi_Minh";

  security.polkit.enable = true;
  services.printing.enable = true;
  services.libinput.enable = true;

  programs.firefox.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.nixos-user = {
    isNormalUser = true;
    description = "NixOS User";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    packages = with pkgs; [
      tree gcc gnumake ncurses elfutils bison flex openssl perl
    ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
  };
}

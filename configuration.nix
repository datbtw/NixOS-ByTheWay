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

    ./power.nix
  ];
  zramSwap = {
	enable = true;
	priority = 100;
	algorithm = "lz4";
	memoryPercent = 50;
     };
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
  services.printing.enable = false;
  services.libinput.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/etc/nixos";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;

    # Module x11-bell của pipewire segfault (SIGSEGV trong x11_io_error_exit_handler)
    # khi Xwayland chết lúc shutdown -> sinh coredump mỗi lần tắt máy.
    # Condition của module là `module.x11.bell = !false`, nên set false để nó không load.
    # Chỉ mất tiếng "bell" của X11, không ảnh hưởng âm thanh.
    extraConfig.pipewire."99-disable-x11-bell" = {
      "context.properties"."module.x11.bell" = false;
    };
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

  programs.hyprland = {
    enable = true;
    withUWSM = true;   
                       
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";   # fix cursor không hiện/giật trên 1 số GPU Intel/NVIDIA
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    configPackages = [ pkgs.hyprland ];
  };

  security.pam.services.hyprlock = { };

  environment.systemPackages = with pkgs; [
    # polkit agent cho Hyprland. KDE Plasma đã có agent riêng
    # (polkit-kde-authentication-agent-1, autostart sẵn) nên KHÔNG cài
    # polkit_gnome nữa: autostart của nó sẽ tranh slot agent với KDE
    # ("An authentication agent already exists for the given subject").
    hyprpolkitagent
  ];
}

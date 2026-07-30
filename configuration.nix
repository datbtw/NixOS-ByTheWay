# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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

  services.fstrim.enable = true;             

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ]; 
  };

  environment.sessionVariables = {
    NIXOS_OZONE_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    SDL_VIDEODRIVER = "wayland";
    LIBVA_DRIVER_NAME = "iHD";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    FCITX_ADDON_DIRS = "${pkgs.fcitx5-lotus}/lib/fcitx5";
    SDL_IM_MODULE = "fcitx";
  };

  environment.variables.LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [ fcitx5-gtk fcitx5-lotus ];
      waylandFrontend = true;
    };
  };

  boot.loader.systemd-boot.enable = true;     
  boot.loader.grub.enable = false;            
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];
    boot.initrd.supportedFilesystems = [ "btrfs" ];
    services.btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };
  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Ho_Chi_Minh";

  programs.niri.enable = true;                 
  programs.firefox.enable = true;
  programs.gamemode.enable = true;             
  programs.mango.enable = true;
  programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/etc/nixos";
    };
  services.fcitx5-lotus = {
    enable = true;
    users = [ "nixos-user" ];
  };
  services.upower.enable = true;               
  hardware.bluetooth.enable = true;            
  services.power-profiles-daemon.enable = true;
  services.printing.enable = true;             
  services.libinput.enable = true;

  security.polkit.enable = true;             

  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

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

  environment.systemPackages = with pkgs; [
    vim
    wget
    wireplumber
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    networkmanagerapplet 
    git
    gnumake 
    libva-utils  
    intel-media-driver
    libva-vdpau-driver
    libvdpau-va-gl
    fuzzel
    xwayland-satellite
    brightnessctl
    wmenu grim slurp  wl-clipboard polkit_gnome
 ];
}

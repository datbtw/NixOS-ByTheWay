# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # =========================================================================
  # CẤU HÌNH KERNEL (Dòng dự phòng nằm ngay bên dưới)
  # =========================================================================
  # boot.kernelPackages = pkgs.linuxPackages_latest; 


  # 1. Giới hạn tài nguyên build (đưa ra ngoài để tránh lỗi)
  # Máy chạy êm, không nóng ran khi rebuild
nix.settings = {
    cores = 12;
    sandbox = false;
    # Nhét 2 dòng này vào TRONG khối nix.settings luôn
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  }; 

  # 2. Bật các service bắt buộc mà tài liệu yêu cầu
  programs.niri.enable = true;           # Bật compositor Niri chính chủ
  services.upower.enable = true;         # Bật hiển thị phần trăm Pin
  hardware.bluetooth.enable = true;      # Bật quản lý Bluetooth
  services.power-profiles-daemon.enable = true; # Quản lý điện năng (Noctalia cần)
  # =========================================================================
  # 1. HỆ THỐNG GỐC (BASE SYSTEM) - CHẠY STABLE ĐẦU 7 MỚI NHẤT (ĂN SẴN CACHE)
  #    (Gọi chuẩn top-level alias của Nixpkgs)
  # =========================================================================
  # 1. Daily Driver: Chính thức đưa siêu phẩm CachyOS LTO lên làm mặc định
  boot.kernelPackages = pkgs.linuxPackages_cachyos-lto;

  # =========================================================================
  # 2. CÁC BIẾN THỂ PHỤ (SPECIALISATION)
  # =========================================================================
  specialisation = {

    # Menu phụ 1: Chạy hàng RC (Testing) từ cục nhân trần vanilla
    # (Do ông dùng lib.mkForce nên nó sẽ đè bẹp thằng CachyOS ở trên khi ông chọn boot vào RC)
    rc.configuration = {
      boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.linuxKernel.kernels.linux_testing);
    };

    # Menu phụ 2: Chạy hàng Next tự compile từ source code Git (Giữ nguyên vẹn không sứt mẻ một phân)
    next.configuration = {
      boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor (pkgs.buildLinux {
        version = "7.2.0-next-20260703";
        modDirVersion = "7.2.0-rc1-next-20260703";
        src = inputs.linux-next-src;
        kernelPatches = [ ];
        extraMeta.branch = "next";
      }));
    };

  };
  networking.hostName = "nixos-btw"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = { inherit inputs; };
  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";
  nix.settings.auto-optimise-store = true;
  
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos-user = {
    isNormalUser = true;
    description = "NixOS User";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree gcc gnumake ncurses elfutils bison flex openssl perl 
    ];
  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    wireplumber
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
    networkmanagerapplet 
    git
    gnumake libva-utils  
    intel-media-driver
    libva-vdpau-driver
    libvdpau-va-gl
fuzzel
  xwayland-satellite
brightnessctl
  ];

  system.stateVersion = "26.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
environment.sessionVariables = {
    NIXOS_OZONE_PLATFORM = "wayland";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "iHD"; # Ép hệ thống dùng intel-media-driver
  };
# Kích hoạt dịch vụ quản lý profile điện năng
  
  powerManagement.cpuFreqGovernor = "performance";
environment.variables.LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";
hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];
#programs.ccache.enable = true;
#programs.ccache.cacheDir = "/var/cache/ccache";
#nix.settings.extra-sandbox-paths = [ config.programs.ccache.cacheDir ];
}

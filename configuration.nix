# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [ 
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # =========================================================================
  # 👑 NIX & SYSTEM SETTINGS (QUY HOẠCH GỌN GÀNG)
  # =========================================================================
  nix = {
    settings = {
      cores = 12;                 # Khóa 12 luồng xử lý cho P-Cores
      sandbox = false;            # Tắt sandbox theo cấu hình cũ của ông
      auto-optimise-store = true; # Tự động hard-link các file trùng lặp để tiết kiệm ổ cứng
      experimental-features = [ "nix-command" "flakes" ];
      
      # Bộ nhớ đệm (Binary Cache) của Noctalia
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  
  # Đổi sang .default để đồng bộ hoàn hảo với nhánh master/unstable (26.11-pre) trên máy ông
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.default ];

  system.stateVersion = "26.05"; # Giữ nguyên phân vùng gốc của ông

  # =========================================================================
  # 🚀 KERNEL & SPECIALISATION (HỆ THỐNG 3 NHÂN TỰ ĐỘ KHÉT LẸT)
  # =========================================================================
  # 1. MẶC ĐỊNH: Nhân CachyOS Latest + Clang ThinLTO + Tối ưu hóa x86_64-v3 (Ăn theo nixpkgs master)
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

  specialisation = {
    # 🛑 BIẾN THỂ 1: Nhân CachyOS RC (Release Candidate) tracking chuẩn chỉ
    rc.configuration = {
      boot.kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-rc;
    };

    # 🏎️ BIẾN THỂ 2: Quái vật phòng thí nghiệm "linux-next" tự độ bằng Clang ThinLTO + BORE Scheduler
    next.configuration = {
      boot.kernelPackages = lib.mkForce (
        let
          customCachyNext = pkgs.cachyosKernels.linux-cachyos-latest.override {
            pname = "linux-cachyos-next";
            version = "7.2.0-next-20260706";
            src = inputs.linux-next-src; # Thọc trực tiếp mã nguồn local của ông vào

            # Tham số độ nhân sử dụng framework của xddxdd
            cpusched = "bore";          # Ép nhân ăn Scheduler BORE mượt mà
            lto = "thin";               # Bật Clang ThinLTO tối ưu sâu
            processorOpt = "x86_64-v3"; # Tối ưu hóa riêng cho kiến trúc chip đời mới
            bbr3 = true;                # Kích hoạt thuật toán mạng siêu tốc BBRv3
            ccHarder = true;            # Ép compiler tối ưu bạo lực tối đa
          };
        in
        # Hỗ trợ cấu hình Clang LTO tránh lỗi các out-of-tree modules
        (pkgs.callPackage "${inputs.nix-cachyos-kernel}/helpers.nix" {}).kernelModuleLLVMOverride 
          (pkgs.linuxKernel.packagesFor customCachyNext)
      );
    };
  };

  # =========================================================================
  # 💻 TỐI ƯU PHẦN CỨNG LAPTOP & SYSCTL (BÙA TĂNG TỐC)
  # =========================================================================
  hardware.cpu.intel.updateMicrocode = true; # Cập nhật vi mã CPU Intel đời mới
  services.thermald.enable = true;          # Kiểm soát nhiệt độ laptop thông minh
  services.fstrim.enable = true;             # Tự động dọn block rác SSD hằng tuần để giữ tốc độ
  powerManagement.cpuFreqGovernor = "performance"; # Ép chạy hiệu năng cao

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;             # Cần thiết cho các tác vụ nặng/gaming
    "net.core.default_qdisc" = "fq";             # Tối ưu hàng đợi mạng
    "net.ipv4.tcp_congestion_control" = "bbr";   # Thuật toán mạng tăng tốc của Google
    "vm.swappiness" = 10;                        # Chỉ hoán đổi khi thực sự cạn kiệt RAM
  };

  # =========================================================================
  # 🎨 GRAPHICS, DISPLAY & ENVIRONMENT VARIABLES (FOR WAYLAND/NIRI NATIVE)
  # =========================================================================
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ]; # Tăng tốc phần cứng cho card Intel
  };

  environment.sessionVariables = {
    NIXOS_OZONE_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";         # Ép đống app Electron/Chromium chạy native Wayland
    MOZ_ENABLE_WAYLAND = "1";     # Ép Firefox chạy native Wayland
    MOZ_DISABLE_RDD_SANDBOX = "1";
    SDL_VIDEODRIVER = "wayland";  # Ép app/game dùng SDL ăn Wayland gốc
    LIBVA_DRIVER_NAME = "iHD";    # Ép hệ thống dùng intel-media-driver
  };

  environment.variables.LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";

  # =========================================================================
  # 🌐 SERVICES, COMPOSITORS & NETWORKING (ĐÃ FIX BOOTLOADER VÀ GRUB)
  # =========================================================================
  boot.loader.systemd-boot.enable = true;     # Trả lại tên cho em
  boot.loader.grub.enable = false;            # Diệt tận gốc con ma Ghost GRUB của cụm master
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Ho_Chi_Minh";

  programs.niri.enable = true;                  # Compositor Niri chính chủ
  programs.firefox.enable = true;
  programs.gamemode.enable = true;              # Tự động dồn lực CPU khi chạy tác vụ nặng
  
  services.upower.enable = true;                # Hiển thị phần trăm Pin
  hardware.bluetooth.enable = true;             # Bật quản lý Bluetooth
  services.power-profiles-daemon.enable = true; # Quản lý cấu hình điện năng (Noctalia cần)
  services.printing.enable = true;              # Dịch vụ in ấn CUPS
  services.libinput.enable = true;              # Hỗ trợ Touchpad mượt mà

  # Bật XServer, GNOME và GDM song song theo cấu hình gốc của ông
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Hệ thống âm thanh PipeWire chuyên nghiệp
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # =========================================================================
  # 👤 USER ACCOUNTS & PACKAGES (GIỮ NGUYÊN VẸN ĐỒ CHƠI)
  # =========================================================================
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
  ];
}

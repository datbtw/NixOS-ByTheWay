# Caelestia Shell: bar, app launcher, notification, wallpaper picker.
# Thay thế cho Waybar + Rofi + swaync truyền thống -> 1 shell thống nhất
# (giống Noctalia nhưng phong cách Material You, bo góc, pastel).
{ config, inputs, pkgs, ... }:

{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  # App cần thiết để Caelestia hoạt động đầy đủ, khai báo ngay trong file này.
  home.packages = with pkgs; [
    matugen                # sinh màu theme động (Material You) từ wallpaper
    app2unit                # chuyển .desktop entry thành systemd unit cho launcher
    qt6Packages.qt6ct                   # theme Qt app đồng bộ với Caelestia
    nerd-fonts.jetbrains-mono  # font hiển thị icon trong bar/launcher
  ];

  programs.caelestia = {
    enable = true;
    cli.enable = true;

    # systemd = false vì đã autostart qua exec-once trong hyprland.nix
    systemd.enable = false;

    settings = {
      bar.status.showBattery = true;
      paths.wallpaperDir = "${config.home.homeDirectory}/Pictures/Wallpapers";
    };
  };
}

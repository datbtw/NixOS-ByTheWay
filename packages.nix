# Danh sách package cài đặt toàn hệ thống.
{ pkgs, ... }:

{
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
    wmenu
    grim
    slurp
    wl-clipboard
    polkit_gnome
  ];
}

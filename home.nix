{ config, pkgs, inputs, ... }:
let
  unilume = pkgs.callPackage ./unilume.nix { };
in {
  imports = [
    inputs.noctalia.homeModules.default
    ./mango-home.nix
    ./niri-home.nix
    ./noctalia-home.nix
    ./chrome-home.nix
    ./iris-home.nix
    ./shell.nix
    ./theme-home.nix
    ./polkit-agent-home.nix
  ];

  home.username = "nixos-user";
  home.homeDirectory = "/home/nixos-user";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    spotify fastfetch gnome-tweaks alacritty fish foot
    discord flatpak libreoffice-fresh psmisc bibata-cursors
    vlc cava cmatrix figlet htop btop
    unilume hw-probe
  ];

  # i18n.inputMethod đã được gộp về configuration.nix -> input-method.nix
  # (system-level), không khai báo lại ở đây để tránh xung đột addon list
  # giữa Lotus / bamboo / unilume.

  programs.home-manager.enable = true;
}

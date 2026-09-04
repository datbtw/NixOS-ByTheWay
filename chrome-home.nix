{ pkgs, ... }:
{
  home.packages = [
    (pkgs.google-chrome.override {
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
    })
  ];
}

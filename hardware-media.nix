# Graphics, video acceleration, Wayland env vars, bluetooth, power management.
{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  environment.variables.LIBVA_DRIVERS_PATH = "/run/opengl-driver/lib/dri";

  environment.sessionVariables = {
    NIXOS_OZONE_PLATFORM = "wayland";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    SDL_VIDEODRIVER = "wayland";
    LIBVA_DRIVER_NAME = "iHD";
  };

  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}

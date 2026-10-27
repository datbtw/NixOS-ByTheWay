# Desktop environment, window managers, display manager.
{ ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable= true;
  services.desktopManager.plasma6.enable= true;
  programs.gamemode.enable = true;
}

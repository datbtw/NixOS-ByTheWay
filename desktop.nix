# Desktop environment, window managers, display manager.
{ ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  programs.gamemode.enable = true;
}

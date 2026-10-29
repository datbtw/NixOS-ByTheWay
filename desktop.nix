{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  programs.gamemode.enable = true;

  services.printing.enable = false;
  environment.plasma6.excludePackages = [ pkgs.kdePackages.print-manager ];
}

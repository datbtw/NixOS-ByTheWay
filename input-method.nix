# Toàn bộ cấu hình bộ gõ fcitx5 gộp về 1 chỗ duy nhất (system-level).
# Trước đây bị khai báo 2 lần (configuration.nix + home.nix) với 2 addon list
# khác nhau (fcitx5-lotus ở system, unilume+fcitx5-bamboo ở home) -> đã gộp
# về đây để tránh xung đột.
{ pkgs, ... }:
let
  unilume = pkgs.callPackage ./unilume.nix { };
in
{
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-bamboo
        unilume
      ];
      waylandFrontend = true;
    };
  };

  services.fcitx5-lotus = {
    enable = true;
    users = [ "nixos-user" ];
  };
}

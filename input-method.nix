# Toàn bộ cấu hình bộ gõ fcitx5 gộp về 1 chỗ duy nhất (system-level).
# Trước đây bị khai báo 2 lần (configuration.nix + home.nix) với 2 addon list
# khác nhau (fcitx5-lotus ở system, unilume+fcitx5-bamboo ở home) -> đã gộp
# về đây để tránh xung đột.
{ pkgs, ... }:
let
  unilume = pkgs.callPackage ./unilume.nix { };
in
{
  # Trên Wayland + Hyprland, GTK3/4 và Qt dùng input-method-v2/text-input-v3 native
  # nên KHÔNG set GTK_IM_MODULE/QT_IM_MODULE (sẽ chồng 2 đường gõ -> loạn gõ).
  # waylandFrontend = true dưới đây vốn đã tự bỏ 2 biến đó; chỉ cần XMODIFIERS cho
  # app XWayland (do module fcitx5 của nixpkgs set sẵn).
  environment.sessionVariables = {
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
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

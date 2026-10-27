{ ... }:

{
  programs.noctalia = {
    enable = true;
    systemd.enable = false; # Đã đổi thành false để tránh tự khởi động khi vào KDE Plasma
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      launch_apps_as_systemd_services = true;
    };
  };
}

# Polkit authentication agent chạy dưới session người dùng.
{ pkgs, ... }:

{
  systemd.user.services.polkit-agent = {
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}

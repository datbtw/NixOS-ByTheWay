# Tắt máy nhanh hơn: KDE plasmashell (6.8.x) nhiều lúc không thoát khi nhận SIGTERM
# (thường do KIO worker / applet còn treo), nên systemd phải đợi hết TimeoutStopSec
# mặc định của unit (40s) rồi mới SIGKILL. Trong 40s đó màn hình shutdown hiện
# "A stop job is running for User Manager for UID 1000".
#
# Hạ timeout stop của riêng plasmashell xuống 5s -> gần như không còn thấy chờ.
# (Trước đây sau 40s nó cũng bị SIGKILL, nên không mất thêm gì.)
{ ... }:

{
  xdg.configFile."systemd/user/plasma-plasmashell.service.d/override.conf".text = ''
    [Service]
    TimeoutStopSec=5s
  '';
}

# Overlay vá Hyprland đang bị lỗi build trên nixpkgs master.
#
# Nguyên nhân: nixpkgs master vừa bump glaze lên 8.0.0, nhưng Hyprland 0.56.1
# vẫn yêu cầu glaze < 8 (`find_package(glaze 7...<8 QUIET)`). Vì không tìm thấy
# glaze tương thích, CMake rơi vào FetchContent để tải glaze v7.2.0 từ GitHub —
# nhưng trong build sandbox không có `git` nên lỗi:
#   "error: could not find git for clone of glaze"
#
# Giải pháp: ép glaze về 7.9.1 (phiên bản Hyprland 0.56.1 được build cùng).
# Bỏ overlay này khi nixpkgs đã nâng Hyprland lên bản hỗ trợ glaze 8.
final: prev: {
  glaze = prev.glaze.overrideAttrs (old: {
    version = "7.9.1";
    src = prev.fetchFromGitHub {
      owner = "stephenberry";
      repo = "glaze";
      tag = "v7.9.1";
      hash = "sha256-NRRq5MGF2f5PW0teYnq58ELzson+U6KHVPaY6r30KLA=";
    };
  });
}

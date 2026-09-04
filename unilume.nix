{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, fcitx5, gettext }:
stdenv.mkDerivation {
  pname = "unilume";
  version = "0-unstable-2026-08-01";
  src = fetchFromGitHub {
    owner = "LumeWorks";
    repo = "UniLume";
    rev = "5cf0354e98808bff8c115efa471e063c1de75e2b";
    hash = "sha256-02dP/iTLtOg2nXQO6z0ru35M5MSHjdCox36M2M+hrhw=";
  };
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fcitx5 gettext ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUNILUME_BUILD_FCITX5_ADDON=ON"
  ];
  meta = with lib; {
    description = "Modern, lightweight Vietnamese input method for Linux";
    longDescription = ''
      UniLume is a modern Vietnamese input method for Linux, developed directly
      from the UniKey engine. Supports Telex, VNI, and VIQR input methods.
    '';
    homepage = "https://github.com/LumeWorks/UniLume";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [];
  };
}

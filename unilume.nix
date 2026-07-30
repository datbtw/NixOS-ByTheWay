{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, fcitx5, gettext }:

stdenv.mkDerivation {
  pname = "unilume";
  version = "0-unstable-2026-07-29";

  src = fetchFromGitHub {
    owner = "dismonjames";
    repo = "UniLume";
    rev = "main";
    hash = "sha256-QKdtUEzi6MN54TNnahh1guLZ3RaKohVUTOukvsnqxAE=";
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
    homepage = "https://github.com/dismonjames/UniLume";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [];
  };
}

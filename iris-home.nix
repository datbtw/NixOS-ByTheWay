{ lib, pkgs, ... }:

let
  iris = pkgs.buildGoModule {
    pname = "iris";
    version = "unstable-2026-07-29";
    src = pkgs.fetchFromGitHub {
      owner = "versenilvis";
      repo = "IRIS";
      rev = "476ca3946b5e129471663a9269d1481b22fd4963"; # nên thay bằng commit sha cụ thể
      hash = "sha256-oRyFkNvzVQU4br0d9wWhR/qg5WYOjgyeJXm4HWNwYAM=";
    };
    subPackages = [ "cmd/iris" ];
    proxyVendor = true;
    vendorHash ="sha256-KQNloP/Aj283YQ4d5LFu/2Pbb2HbVTZPhLK1fs4xvGw=";
    doCheck = false;
    meta = with lib; {
      description = "A shell auto-completion tool that works like code editor's IntelliSense";
      homepage = "https://github.com/versenilvis/iris";
      license = licenses.bsd0;
      mainProgram = "iris";
    };
  };
in
{
  home.packages = [ iris ];

  programs.fish.interactiveShellInit = ''
    if command -v iris >/dev/null 2>&1
      alias i="iris"
    end
  '';

  xdg.configFile."iris/config.toml".text = ''
    [core]
    version = 1
    shell = "fish"
    mode = "last"
    debug = false
    expand-alias = true

    [ui]
    style = "modern"
    ghost-text = true
    hidden-files = false
  '';
}

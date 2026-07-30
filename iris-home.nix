{ lib, pkgs, ... }:

let
  iris = pkgs.buildGoModule {
    pname = "iris";
    version = "unstable-2026-07-29";
    src = pkgs.fetchFromGitHub {
      owner = "versenilvis";
      repo = "IRIS";
      rev = "main"; # nên thay bằng commit sha cụ thể
      hash = "sha256-eRzUEJd+svdJ0RPwsDzZcxeuDqSUVN5ebZpfuQcS1zI=";
    };
    subPackages = [ "cmd/iris" ];
    proxyVendor = true;
    vendorHash = "sha256-kBSMhUsuCKIjAXjGfl1WSjCX+tlGi9BTnkRu9ScW6M0=";
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

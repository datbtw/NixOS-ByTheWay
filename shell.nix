# Cấu hình shell: bash tự động exec vào fish, fish aliases.
{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $- == *i* ]];
      then
        exec fish
      fi
    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
      fish_add_path "$HOME/.local/bin"
    '';
    shellAliases = {
      btw = "echo 'I Use NixOS By The Way!'";
      fetch = "fastfetch";
    };
  };
}

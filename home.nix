# Chỗ sửa 1: Thêm 'inputs' vào dấu ngoặc nhọn đầu file để home.nix có quyền gọi Flake
{ config, pkgs, inputs, ... }: 
{
	# Chỗ sửa 2: Tạo một khối imports để nạp module Noctalia v5 vào Home Manager
	imports = [
		inputs.noctalia.homeModules.default
	];

	home.username = "nixos-user";
	home.homeDirectory = "/home/nixos-user";
	home.stateVersion = "26.05";
	home.packages = with pkgs; [
		google-chrome spotify fastfetch gnome-tweaks alacritty fish
		discord flatpak libreoffice-fresh psmisc bibata-cursors vlc cava cmatrix figlet htop btop 
	];
	home.pointerCursor = {
		gtk.enable = true;
		x11.enable = true;
		package = pkgs.bibata-cursors;
		name = "Bibata-Modern-Classic";
		size = 24;
	};
	i18n.inputMethod = {
		enable = true;
		type = "fcitx5";
		fcitx5.addons = with pkgs; [fcitx5-bamboo];
	};
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
		interactiveShellInit =''
			set -g fish_greeting ""
			fish_add_path "$HOME/.local/bin"
	        '';
		shellAliases = {
			btw = "echo 'I Use NixOS By The Way!'";
			fetch = "fastfetch";
		};
	};

	# Chỗ sửa 3: Chèn khối cấu hình giao diện Noctalia v5 vào đây
	programs.noctalia = {
		enable = true;
		systemd.enable = true; # Tự động chạy cùng Niri qua systemd
		settings = {
			theme = {
				mode = "dark";
				source = "builtin";
				builtin = "Catppuccin";
			};
			wallpaper = {
				enabled = true;
				# Nhớ vứt 1 tấm ảnh tên wallpaper.png vào thư mục Pictures hoặc đổi đường dẫn này nhé
				default.path = "/home/nixos-user/Pictures/wallpaper.png"; 
			};
			launch_apps_as_systemd_services = true;
		};
	};

	programs.home-manager.enable = true;
}

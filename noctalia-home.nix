{ ... }:

{
	programs.noctalia = {
		enable = true;
		systemd.enable = true;
		settings = {
			theme = {
				mode = "dark";
				source = "builtin";
				builtin = "Catppuccin";
			};
			wallpaper = {
				enabled = true;
				default.path = "/home/nixos-user/Pictures/wallpaper.png";
			};
			launch_apps_as_systemd_services = true;
		};
	};
}

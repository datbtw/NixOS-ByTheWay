# Cấu hình Hyprland qua module Home Manager chính thức (wayland.windowManager.hyprland).
# Toàn bộ config được viết trực tiếp bằng Lua (configType = "lua") trong `extraConfig`,
# thay vì attrset Nix -> dùng được full API Lua (hl.config, hl.dsp, hl.on, ...).
#
# LƯU Ý:
# - Chỉ Hyprland hỗ trợ config dạng Lua. Hyprlock/Hypridle chỉ nhận hyprlang
#   (không có Lua) nên phần dưới vẫn giữ dạng attrset Nix.
# - Phải bật thêm ở configuration.nix (system-level): programs.hyprland.enable,
#   xdg.portal, security.pam.services.hyprlock (xem hướng dẫn cuối file khi present).
{ pkgs, ... }:

{
  # App cần thiết cho Hyprland hoạt động đầy đủ, khai báo ngay trong file này
  # để tự chứa (self-contained), không phụ thuộc packages.nix bên ngoài.
  home.packages = with pkgs; [
    alacritty              # terminal chính dùng trong keybind
    grim                  # chụp màn hình
    slurp                 # chọn vùng màn hình
    wl-clipboard          # clipboard Wayland
    cliphist              # lịch sử clipboard
    brightnessctl         # chỉnh độ sáng
    playerctl             # điều khiển media
    hyprpicker             # color picker
    hyprcursor             # cursor theme engine của Hyprland
    hyprsunset             # blue light filter (giống redshift)
    pyprland               # scratchpad, tính năng mở rộng cho Hyprland
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    # Tắt systemd integration của Home Manager vì đã dùng UWSM
    # (programs.hyprland.withUWSM = true ở configuration.nix) — 2 bên
    # cùng quản lý session sẽ xung đột nếu để cả hai bật.
    systemd.enable = false;

    configType = "lua";

    settings = { };

    # Cấu hình Hyprland viết bằng Lua trực tiếp.
    extraConfig = ''
      local mod = "SUPER"
      local terminal = "alacritty"
-- Autostart (tương đương exec-once)
      -- Noctalia shell tự động chạy qua systemd user service
      -- (programs.noctalia.systemd.enable = true, WantedBy=graphical-session.target)
      hl.on("hyprland.start", function()
        hl.exec_cmd("hypridle")
      end)
      -- Monitor — ép scale = 1 (tắt auto scale)
      hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = 1,
      })

      -- Noctalia: cửa sổ settings nổi giữa màn hình
      hl.window_rule({
        match = { class = "dev.noctalia.Noctalia" },
        float = true,
        size = { 1080, 920 },
      })

      -- General / decoration / animation / input
      hl.config({
        general = {
          gaps_in     = 4,
          gaps_out    = 8,
          border_size = 2,
          -- layout scrolling: mở cửa sổ mới thành cột, cuộn sang 2 bên (tích hợp sẵn trong Hyprland)
          layout      = "scrolling",
        },

        -- Tuỳ chỉnh scrolling layout
        scrolling = {
          column_width            = 0.5,   -- độ rộng cột mới (nửa màn hình)
          fullscreen_on_one_column = true, -- chỉ còn 1 cột thì fullscreen
          focus_fit_method         = 1,    -- khi focus, kéo cột đó vào vừa màn hình
          follow_focus             = true, -- tự cuộn theo cửa sổ đang focus
          wrap_focus               = true, -- focus vòng lại đầu/cuối
          direction                = "right",
        },

        decoration = {
          rounding = 8,
          blur = {
            enabled = true,
            size    = 4,
            passes  = 2,
          },
        },

        animations = {
          enabled = true,
        },

        input = {
          kb_layout    = "us",
          follow_mouse = 1,
          touchpad = {
            natural_scroll = true,
          },
        },
      })

      -- Keybindings (bind)
      hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
      hl.bind(mod .. " + Q", hl.dsp.window.close())
      hl.bind(mod .. " + M", hl.dsp.exit())
      hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))  -- phóng to nhưng vẫn giữ shell bar
      hl.bind(mod .. " + A", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))  -- app launcher qua Noctalia
      hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock")) 		
      hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

      -- Volume / Mute (Noctalia tự bật OSD + âm thanh khi đổi volume)
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true, repeating = true })

      -- Brightness (Noctalia tự bật OSD khi đổi độ sáng)
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { locked = true, repeating = true })

      hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = 1 }))
      hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = 2 }))
      hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = 3 }))
      hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = 4 }))
      hl.bind(mod .. " + 5", hl.dsp.focus({ workspace = 5 }))

      -- Scrolling layout: Alt+Tab chuyển cửa sổ/cột trong cùng workspace
      hl.bind("ALT + Tab", hl.dsp.layout("focus r"))         -- chuyển sang cột tiếp theo
      hl.bind("ALT + SHIFT + Tab", hl.dsp.layout("focus l")) -- chuyển về cột trước
      -- Cuộn / phóng to thu gọn cột
      hl.bind(mod .. " + J", hl.dsp.layout("move -col"))     -- cuộn trái
      hl.bind(mod .. " + L", hl.dsp.layout("move +col"))     -- cuộn phải

      hl.bind(mod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
      hl.bind(mod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
      hl.bind(mod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
      hl.bind(mod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
      hl.bind(mod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))

      -- Mouse binds (tương đương bindm)
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    '';
  };

  # Lock screen — hyprlock chỉ hỗ trợ hyprlang (không có Lua) nên giữ dạng attrset.
  programs.hyprlock = {
    enable = true;
    settings = {
      general.disable_loading_bar = true;
      background = [
        {
          path = "screenshot";
          blur_passes = 2;
        }
      ];
      # Trường nhập password — hiện ngay khi khóa / ấn phím bất kỳ để vào lại.
      # LƯU Ý: hyprlock >= 0.6 đổi tên section `input` thành `input-field`.
      "input-field" = {
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "rgba(ffffff00)";
        inner_color = "rgba(00000080)";
        font_color = "rgba(ffffffff)";
        fade_on_empty = false;
        placeholder_text = "<i>Nhập mật khẩu...</i>";
        hide_input = false;
        rounding = -1;
        check_color = "rgba(00ff00aa)";
        fail_color = "rgba(ff0000aa)";
        capslock_color = "rgba(ffff00aa)";
        numlock_color = "rgba(ffff00aa)";
        bothlock_color = "rgba(ffff00aa)";
        invert_numlock = false;
        swap_font_color = false;
        position = "0, -120";
        halign = "center";
        valign = "center";
      };
    };
  };

  # Idle management — hypridle cũng chỉ nhận hyprlang qua `settings`.
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprlock";
      };
      listener = [
        { timeout = 300; on-timeout = "hyprlock"; }
        {
          timeout = 600;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}

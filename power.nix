{ pkgs, lib, ... }:

{
  services.power-profiles-daemon.enable = lib.mkForce false;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power"; # Hoặc "balance_power" nếu muốn đỡ lag

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 70; # Giới hạn tối đa 70% xung CPU khi dùng pin để mát máy & tiết kiệm pin

      # Ngắt nguồn các thiết bị PCIe/USB không dùng tới khi rút sạc
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersave";

      # Chế độ tiết kiệm điện cho GPU tích hợp (Intel/AMD)
      INTEL_GPU_MIN_FREQ_ON_AC = 0;
      INTEL_GPU_MAX_FREQ_ON_AC = 0; # Unlocked
      INTEL_GPU_BOOST_FREQ_ON_AC = 0;
      INTEL_GPU_MIN_FREQ_ON_BAT = 300;
      INTEL_GPU_MAX_FREQ_ON_BAT = 800;
    };
  };
}

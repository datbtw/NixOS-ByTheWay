{ pkgs, lib, inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  # Bắt buộc để thực sự tải binary thay vì build from source
  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };

  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  hardware.cpu.intel.updateMicrocode = true;
  services.thermald.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "vm.swappiness" = 10;
  };
}

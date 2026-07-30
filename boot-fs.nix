# Bootloader và cấu hình filesystem (btrfs).
{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "btrfs" ];
  boot.initrd.supportedFilesystems = [ "btrfs" ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  services.fstrim.enable = true;
}

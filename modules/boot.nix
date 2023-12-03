{ config, pkgs, ... }: {
  # Bootloader.
  boot.loader = {
    timeout = 1;
    efi = {
      canTouchEfiVariables = true;
    };
    systemd-boot = {
      enable = true;
      consoleMode = "max";
    };
  };

  # Enable plymouth for fancy boot screen.
  boot.initrd.systemd.enable = true;
  boot.kernelParams = [ "quiet" "udev.log_level=3" ];
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  # Use linux_zen
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "usb_storage" "sd_mod" ];
  # add v4l2loopback for obs virtualcam
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;
  # udev rules for adb and vial
  services.udev.packages = with pkgs; [
    android-udev-rules
    vial
  ];
}

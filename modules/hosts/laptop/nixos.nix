{ ... }: {
  imports = [ ../../users/symph/nixos.nix ];

  boot.enable = true;
  # refer: https://lore-kernel.gnuweeb.org/regressions/2026-10-21-1-daily-reply-0019-tiny-power-button-6-18@kernel.org/T/
  # Linux 6.18.57: this driver turns s2idle wake notifications into shutdowns.
  boot.blacklistedKernelModules = [ "tiny_power_button" ];

  # refer: https://gitlab.freedesktop.org/drm/amd/-/issues/3647
  # prevents system freeze
  boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];

  hardware.facter.reportPath = ./facter.json;
  hardware.logitech.wireless.enable = true;
  hardware.audio.enable = true;
  hardware.disableFnLed.enable = true;
  hardware.disko = {
    enable = true;
    disk = "/dev/nvme0n1";
    swap = "16G";
  };

  networking.hostName = "laptop";
  networking.dns.cloudflare.enable = true;

  desktop.enable = true;

  programs.chromium.enable = true;
  programs.steam.enable = true;
}

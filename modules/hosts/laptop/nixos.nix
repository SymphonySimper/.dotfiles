{ ... }: {
  imports = [ ../../users/symph/nixos.nix ];

  boot.enable = true;
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
  networking.blockHosts = [
    "www.youtube.com"
    "www.reddit.com"
    "old.reddit.com"
  ];

  desktop.enable = true;

  theme.fonts.enable = true;

  programs.chromium.enable = true;
}

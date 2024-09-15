{ pkgs, ... }:
{
  imports = [ ./packages/kanata.nix ];

  # Bootloader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };
    kernelParams = [ "quiet" ];
    consoleLogLevel = 0;
  };

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # 80 # 443
      5173
    ];
  };

  # Enable sound with pipewire.
  # sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        alsa-soft-mixer = {
          # refer: https://wiki.archlinux.org/title/PipeWire#No_sound_from_USB_DAC_until_30%_volume
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "device.name" = "~alsa_card.*";
                }
              ];
              actions = {
                update-props = {
                  "api.alsa.soft-mixer" = true;
                };
              };
            }
          ];
        };
      };
    };
  };
  environment.defaultPackages = with pkgs; [
    helvum
    pavucontrol
  ];

  powerManagement.enable = true;
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
}

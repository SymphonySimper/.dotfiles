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

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # 80 # 443
        5173
      ];
    };
    hosts = {
      "0.0.0.0" = [
        # Music
        "music.youtube.com"
        "open.spotify.com"

        # Social Media
        "www.facebook.com"
        "www.fb.com"
        "www.instagram.com"
        "www.twitch.tv"
        "www.twitter.com"
        "www.youtube.com"

        # OTT
        "www.hotstar.com"
        "www.primevideo.com"
        "www.sonyliv.com"
        "www.sunnxt.com"
        "www.zee5.com"
        ## Anime
        "hianime.to"
        "www.crunchyroll.com"

        # Misc
        "store.steampowered.com"
      ];
    };
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  environment.defaultPackages = with pkgs; [
    helvum
    pavucontrol
  ];

  powerManagement.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    # refer: https://linrunner.de/tlp/support/optimizing.html#extend-battery-runtime
    settings = {
      # CPU
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # Platform
      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # Disable turbo boost
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # ABM
      AMDGPU_ABM_LEVEL_ON_AC = 0;
      AMDGPU_ABM_LEVEL_ON_BAT = 3;

      # Runtime 
      RUNTIME_PM_ON_AC = "auto";
      RUNTIME_PM_ON_BAT = "auto";

      # WiFi
      WIFI_PWR_ON_AC = "on";
      WIFI_PWR_ON_BAT = "on";
    };
  };
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = false;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}

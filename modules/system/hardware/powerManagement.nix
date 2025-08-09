{ config, lib, ... }:
let
  cfg = config.my.hardware.powerManagement;
in
{
  options.my.hardware.powerManagement = {
    enable = lib.mkEnableOption "power management";
  };

  config = lib.mkIf cfg.enable {
    powerManagement.enable = true;

    services = {
      auto-cpufreq.enable = lib.mkForce false;
      power-profiles-daemon.enable = lib.mkForce false;
      thermald.enable = config.my.hardware.cpu.intel.enable;

      tlp = {
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

          # # WiFi
          # WIFI_PWR_ON_AC = "on";
          # WIFI_PWR_ON_BAT = "on";
        };
      };
    };
  };
}

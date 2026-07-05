{ den, lib, ... }: {
  den.aspects.apps.chromium = {
    includes = [
      (den.batteries.unfree [
        "chromium"
        "chromium-unwrapped"
        "widevine-cdm"
      ])
    ];

    nixos = {
      imports = [ ./_search.nix ];

      programs.chromium = {
        enable = true;

        extraOpts = {
          # PasswordManagerEnabled = false;
          RestoreOnStartup = 1;
          DefaultBrowserSettingEnabled = false; # do not check for default browser
          GenAiDefaultSettings = 2; # disable all Genarative AI features
          AutofillCreditCardEnabled = false;
          AutofillAddressEnabled = false;
          AutoplayAllowed = false;
          BrowserLabsEnabled = false;

          # Balanced memory savings
          HighEfficiencyModeEnabled = true;
          MemorySaverModeSavings = 1;

          ShowHomeButton = false;
          HomepageIsNewTabPage = true;

          # Brave specific
          # refer: https://support.brave.app/hc/en-us/articles/360039248271-Group-Policy
          BraveRewardsDisabled = true;
          BraveWalletDisabled = true;
          BraveVPNDisabled = true;
          BraveAIChatEnabled = false;
          BraveNewsDisabled = true;
          BraveTalkDisabled = true;
        };
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        imports = [ ./_bookmarks.nix ];

        catppuccin.chromium.enable = false;

        programs.chromium = {
          enable = true;
          package = pkgs.chromium.override { enableWideVine = true; };

          commandLineArgs =
            map (feature: "--${feature.name}-features=${builtins.concatStringsSep "," feature.value}")
              (
                builtins.filter (f: (builtins.length f.value) > 0) (
                  lib.attrsets.mapAttrsToList (name: value: { inherit name value; }) {
                    disable = [ "WebRtcAllowInputVolumeAdjustment" ];
                    enable = [
                      # https://wiki.archlinux.org/title/Chromium#Hardware_video_acceleration
                      "AcceleratedVideoDecodeLinuxGL"
                      "AcceleratedVideoEncoder"
                    ];
                  }
                )
              );
        };
      };
  };
}

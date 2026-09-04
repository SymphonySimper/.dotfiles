{ ... }: {
  imports = [
    ./new-tab.nix
    ./search.nix
  ];

  programs.chromium = {
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
      # BraveRewardsDisabled = true;
      # BraveWalletDisabled = true;
      # BraveVPNDisabled = true;
      # BraveAIChatEnabled = false;
      # BraveNewsDisabled = true;
      # BraveTalkDisabled = true;
    };

    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      "lodbfhdipoipcjmlebjbgmmgekckhpfb" # harper
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    ];
  };
}

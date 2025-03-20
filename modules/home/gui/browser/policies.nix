{ lib, ... }:
{
  DisableAccounts = true;
  DisableFirefoxAccounts = true;
  DisablePocket = true;
  DisableTelemetry = true;
  DisableFirefoxStudies = true;
  DontCheckDefaultBrowser = true;
  DisableProfileImport = true;
  DisableSetDesktopBackground = true;
  HttpsOnlyMode = "force_enabled";

  OfferToSaveLogins = false;
  PasswordManagerEnabled = false;

  FirefoxSuggest = {
    WebSuggestions = false;
    SponsoredSuggestions = false;
    ImproveSuggest = false;
    Locked = true;
  };
  HardwareAcceleration = true;
  PromptForDownloadLocation = true;
  TranslateEnabled = true;
  PictureInPicture = {
    Enabled = true;
    Locked = true;
  };

  DisplayBookmarksToolbar = "never";
  OverrideFirstRunPage = "";
  OverridePostUpdatePage = "";
  NewTabPage = true;
  ShowHomeButton = false;
  FirefoxHome = {
    Search = false;
    TopSites = false;
    SponsoredTopSites = false;
    Highlights = false;
    Pocket = false;
    SponsoredPocket = false;
    Snippets = false;
    Locked = true;
  };
  Homepage.StartPage = "previous-session";

  ExtensionSettings = lib.mkMerge [
    {
      "*".installation_mode = "blocked"; # or `allowed`
    }

    (builtins.listToAttrs (
      builtins.map (extension: {
        name = extension.id;
        value = {
          # https://addons.mozilla.org/en-US/firefox/addon/<slug>
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${extension.slug}/latest.xpi";
          installation_mode = "force_installed";
          # now pinning is handled by ./settings.nix
          # default_area = if lib.my.mkGetDefault extension "pin" false then "navbar" else "menupanel";
          default_area = "menupanel";
          private_browsing = lib.my.mkGetDefault extension "private" false;
        };
      }) (import ./extensions.nix)
    ))
  ];
}

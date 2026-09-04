{ ... }:
let
  # Colors were taken from chrome://new-tab-page-third-party
  html =
    builtins.toFile "new-tab.html" # html
      ''
        <!DOCTYPE html>
        <html>
          <head>
            <title>New Tab</title>
            <style>
              :root {
                background-color: rgb(255,255,255);
              }

              @media (prefers-color-scheme: dark) {
                :root {
                  background-color: rgb(45,45,45);
                }
              }
            </style>
          </head>
        </html>
      '';
in
{
  programs.chromium.extraOpts = rec {
    ShowHomeButton = false;
    HomepageIsNewTabPage = true;
    HomepageLocation = "file://${html}";
    NewTabPageLocation = HomepageLocation;
    DefaultSearchProviderNewTabURL = HomepageLocation;
  };
}

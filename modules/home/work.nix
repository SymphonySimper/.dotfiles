{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.work;
in
{
  options.my.programs.work = {
    enable = lib.mkEnableOption "Work";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.google-cloud-sdk
    ]
    ++ (lib.optional my.gui.enable (
      pkgs.google-chrome.override {
        commandLineArgs = builtins.concatStringsSep " " config.my.programs.browser.args.chromium;
      }
    ));

    my.programs = {
      vcs.profiles."work" = rec {
        host = "github.com";
        email = "176003709+smollan-sri-senthil-balaji@users.noreply.github.com";

        config.user = {
          name = "Sri Senthil Balaji J";
          email = email;
        };
      };

      shell.env.GOOGLE_APPLICATION_CREDENTIALS = "${config.xdg.configHome}/gcloud/application_default_credentials.json";
      editor.ignore = [ "!.gcloudignore" ];
    };
  };
}

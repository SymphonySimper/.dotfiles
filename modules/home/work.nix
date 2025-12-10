{ config, pkgs, ... }:
{
  home.packages = [ pkgs.google-cloud-sdk ];

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
}

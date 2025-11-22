{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkMerge [
    {
      my.programs = {
        vcs.profiles."work-github" = rec {
          name = "work";
          host = "github.com";
          email = "176003709+smollan-sri-senthil-balaji@users.noreply.github.com";

          config = {
            dir = my.dir.work;
            settings = {
              user = {
                name = "Sri Senthil Balaji J";
                email = email;
              };
            };
          };
        };
      };
    }

    {
      home.packages = [ pkgs.google-cloud-sdk ];

      my.programs = {
        shell.env.GOOGLE_APPLICATION_CREDENTIALS = "${config.xdg.configHome}/gcloud/application_default_credentials.json";
        editor.ignore = [ "!.gcloudignore" ];
      };
    }
  ];
}

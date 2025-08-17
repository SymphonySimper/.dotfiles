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
        vcs.root.includes = [
          {
            condition = "gitdir:${my.dir.work}/";
            contents = {
              user = {
                name = "Sri Senthil Balaji J";
                email = "176003709+smollan-sri-senthil-balaji@users.noreply.github.com";
              };
            };
          }
        ];

        ssh.root.matchBlocks."${config.my.programs.vcs.sshHost.work}" = {
          hostname = "github.com";
          identityFile = "${config.my.programs.ssh.dir}/work_id_ed25519";
          identitiesOnly = true;
        };
      };
    }

    {
      home.packages = [ pkgs.google-cloud-sdk ];
      my.programs.shell.env.GOOGLE_APPLICATION_CREDENTIALS =
        "${config.xdg.configHome}/gcloud/application_default_credentials.json";
    }
  ];
}

{ config, ... }:
let
  defaultDirConfig = {
    d = {
      group = "users";
      user = config.my.user.name;
      mode = "0755";
    };
  };
in
{
  systemd.tmpfiles.settings = {
    "${config.my.user.name}-fav-dirs" = {
      "${config.my.directory.dev.path}" = defaultDirConfig;
      "${config.my.directory.dev.path}/work" = defaultDirConfig;
      "${config.my.directory.data.path}" = defaultDirConfig;
    };
  };
}

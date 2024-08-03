{ userSettings, ... }:
{
  programs.nixvim = {
    plugins.neorg = {
      enable = true;
      modules = {
        "core.defaults" = {
          __empty = null;
        };
        "core.concealer" = {
          __empty = null;
        };
        "core.dirman" = {
          config = {
            workspaces = {
              notes = "~/${userSettings.dirs.importantnt}/notes";
              diary = "~/${userSettings.dirs.importantnt}/diary";
            };
            default_workspace = "notes";
          };
        };
      };
    };
  };
}

{ userSettings, ... }:
{
  programs.nixvim = {
    plugins = {
      neorg = {
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
                heart = "~/${userSettings.dirs.importantnt}/heart";
              };
              default_workspace = "notes";
            };
          };
          "core.esupports.metagen" = {
            config.author = "${userSettings.name.name}";
          };
          "core.journal" = {
            config = {
              journal_folder = "journal";
              workspace = "heart";
            };
          };
          "core.completion" = {
            config.engine = "nvim-cmp";
          };
        };
      };

      cmp.settings.sources = [ { name = "neorg"; } ];
    };
  };
}

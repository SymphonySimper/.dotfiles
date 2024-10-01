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
                brain = "~/${userSettings.dirs.importantnt}/brain"; # General
                heart = "~/${userSettings.dirs.importantnt}/heart"; # Personal
                hand = "~/${userSettings.dirs.importantnt}/hand"; # Helps myself and others
              };
              default_workspace = "brain";
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

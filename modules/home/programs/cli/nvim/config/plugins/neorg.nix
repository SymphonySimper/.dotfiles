{ config, ... }:
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
                brain = "${config.my.directory.data.path}/brain"; # General
                heart = "${config.my.directory.data.path}/heart"; # Personal
                hand = "${config.my.directory.data.path}/hand"; # Helps myself and others
              };
              default_workspace = "brain";
            };
          };
          "core.esupports.metagen" = {
            config.author = "${config.my.user.fullName}";
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

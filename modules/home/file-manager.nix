{
  my,
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.programs.file-manager = lib.my.mkCommandOption {
    category = "File Manager";
    command = "yazi";
  };

  config = {
    programs.yazi = lib.mkMerge [
      {
        enable = true;
        shellWrapperName = "y";

        settings = {
          preview.max_width = 1920; # image preview
          mgr.linemode = "size";

          opener.edit = [
            {
              run = ''${config.my.programs.editor.command} "$@"'';
              block = true;
            }
          ];

          open.prepend_rules = [
            {
              mime = "{audio,video}/*";
              use = [
                "open"
                "reveal"
              ];
            }
          ];
        };
      }

      (lib.mkIf my.gui.enable {
        extraPackages = [ pkgs.ripdrag ];
        keymap.mgr.prepend_keymap = [
          {
            on = "<C-n>";
            run = # sh
              ''
                shell 'ripdrag "$@" -x 2>/dev/null &' --confirm
              '';
            desc = "Drag and drop using ripdrag";
          }
        ];
      })

      # Plugins
      (lib.mkIf (my.profile != "wsl") {
        plugins.mount = pkgs.yaziPlugins.mount;
        keymap.mgr.prepend_keymap = [
          {
            on = "M";
            run = "plugin mount";
          }
        ];
      })
    ];
  };
}

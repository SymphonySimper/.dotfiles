{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.file-manager;
in
{
  options.my.programs.file-manager = lib.my.mkCommandOption {
    category = "File Manager";
    command = "yazi";
  };

  config = {
    my.programs = {
      desktop.keybinds = [
        {
          key = "e";
          mods = [ "super" ];
          command = "${config.my.programs.terminal.command} ${config.my.programs.terminal.args.command} ${cfg.command}";
        }
      ];
    };

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
      package = pkgs.yazi.override {
        optionalDeps = [ pkgs.p7zip ] ++ (lib.lists.optional my.gui.enable pkgs.ripdrag);
      };

      settings = {
        mgr.linemode = "mtime";

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

      keymap.mgr.prepend_keymap = lib.lists.optional my.gui.enable {
        on = "<C-n>";
        run = # sh
          ''
            shell 'ripdrag "$@" -x 2>/dev/null &' --confirm
          '';
        desc = "Drag and drop using ripdrag";
      };
    };
  };
}

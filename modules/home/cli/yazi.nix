{
  inputs,
  pkgs,
  my,
  ...
}:
{
  programs.yazi = {
    enable = true;
    # package = inputs.yazi.packages.${pkgs.system}.default;
    enableBashIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        ratio = [
          1 # left
          3 # center
          4 # right
        ];
        linemode = "size";
      };
      preview = {
        max_width = my.gui.display.width / 2;
        max_height = my.gui.display.height / 2;
        ueberzug_scale = my.gui.display.scale / 2;
        ueberzug_offset = [
          ((my.gui.display.scale * 10) + my.gui.display.scale) # x
          (my.gui.display.scale) # y
          (0.0) # w
          (0.0) # h
        ];
      };
      opener = {
        edit = [
          {
            run = ''${my.programs.editor} "$@"'';
            block = true;
            for = "unix";
          }
        ];
        play = [
          {
            run = ''${my.programs.video} "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
        open = [
          {
            run = ''xdg-open "$@"'';
            desc = "Open";
          }
        ];
      };
      open = {
        rules = [
          {
            name = "*/";
            use = [
              "open"
              "edit"
              "reveal"
            ];
          }

          {
            mime = "text/*";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            mime = "image/*";
            use = [
              "open"
              "reveal"
            ];
          }
          {
            mime = "video/*";
            use = [
              "play"
              "reveal"
            ];
          }
          {
            mime = "audio/*";
            use = [
              "play"
              "reveal"
            ];
          }
          {
            mime = "inode/x-empty";
            use = [
              "edit"
              "reveal"
            ];
          }

          {
            mime = "application/json";
            use = [
              "edit"
              "reveal"
            ];
          }
          {
            mime = "*/javascript";
            use = [
              "edit"
              "reveal"
            ];
          }

          {
            mime = "application/zip";
            use = [
              "extract"
              "reveal"
              "archive"
            ];
          }
          {
            mime = "application/gzip";
            use = [
              "extract"
              "reveal"
              "archive"
            ];
          }
          {
            mime = "application/x-tar";
            use = [
              "extract"
              "reveal"
              "archive"
            ];
          }
          {
            mime = "application/x-bzip";
            use = [
              "extract"
              "reveal"
              "archive"
            ];
          }
          {
            mime = "application/x-bzip2";
            use = [
              "extract"
              "reveal"
              "archive"
            ];
          }
          {
            mime = "application/x-7z-compressed";
            use = [
              "extract"
              "reveal"
              "archive"
            ];
          }
          {
            mime = "application/x-rar";
            use = [
              "extract"
              "reveal"
              "archive"
            ];
          }
          {
            name = "*";
            use = [
              "open"
              "reveal"
            ];
          }
        ];
      };
      plugin = {
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
      };
    };

    plugins = {
      max-preview = "${inputs.yazi-plugins}/max-preview.yazi/";
      git = "${inputs.yazi-plugins}/git.yazi/";
    };

    keymap = {
      manager.prepend_keymap = [
        {
          on = "T";
          run = "plugin --sync max-preview";
          desc = "Maximize or restore preview";
        }
        {
          on = "<C-n>";
          run = # sh
            ''
              shell '${pkgs.ripdrag}/bin/ripdrag "$@" -x 2>/dev/null &' --confirm
            '';
          desc = "Drag and drop using ripdrag";
        }
      ];
    };

    initLua = # lua
      ''
        require("git"):setup()
      '';
  };

  home.packages = [ pkgs.ueberzugpp ];
}

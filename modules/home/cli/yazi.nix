{
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
    };

    keymap = {
      manager.prepend_keymap = [
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
  };

  home.packages = [ pkgs.ueberzugpp ];
}

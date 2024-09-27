{
  inputs,
  pkgs,
  userSettings,
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
        max_height = 1920;
        max_width = 1080;
        ueberzug_scale = 1.5;
        ueberzug_offset = [
          (-28.0) # x
          (0.0) # y
          (0.0) # w
          (0.0) # h
        ];
      };
      opener = {
        edit = [
          {
            run = ''${userSettings.programs.editor} "$@"'';
            block = true;
            for = "unix";
          }
        ];
        play = [
          {
            run = ''${userSettings.programs.video} "$@"'';
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
    plugins = {
      max-preview = "${inputs.yazi-plugins}/max-preview.yazi/";
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
          run = ''
            shell '${pkgs.ripdrag}/bin/ripdrag "$@" -x 2>/dev/null &' --confirm
          '';
          desc = "Drag and drop using ripdrag";
        }
      ];
    };
  };

  home.packages = [ pkgs.ueberzugpp ];
}

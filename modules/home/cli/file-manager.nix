{
  my,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    chafa
  ];

  programs.yazi = lib.mkMerge [
    {
      enable = true;
      # package = inputs.yazi.packages.${pkgs.system}.default;
      enableBashIntegration = true;
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

        open.rules = [
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

    }

    # Plugins
    {
      plugins.mount = "${inputs.yazi-plugins}/mount.yazi";
      keymap.manager.prepend_keymap = [
        {
          on = "M";
          run = "plugin mount";
        }

        {
          on = "<C-n>";
          run = # sh
            ''
              shell '${lib.getExe pkgs.ripdrag} "$@" -x 2>/dev/null &' --confirm
            '';
          desc = "Drag and drop using ripdrag";
        }
      ];
    }
    {
      plugins.jump-to-char = "${inputs.yazi-plugins}/jump-to-char.yazi";
      keymap.manager.prepend_keymap = [
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
      ];
    }
  ];
}

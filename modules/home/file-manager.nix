{
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
        # package = inputs.yazi.packages.${pkgs.system}.default;
        enableBashIntegration = true;
        shellWrapperName = "y";

        settings = {
          mgr = {
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
                run = ''${config.my.programs.editor.command} "$@"'';
                block = true;
                for = "unix";
              }
            ];

            open = [
              {
                run = ''xdg-open "$@"'';
                desc = "Open";
                for = "linux";
              }
            ];

            reveal = [
              {
                run = ''xdg-open "$(dirname "$1")"'';
                desc = "Reveal";
                for = "linux";
              }
            ];

            extract = [
              {
                run = ''ya pub extract --list "$@"'';
                desc = "Extract here";
                for = "unix";
              }
            ];

            play = [
              {
                run = ''xdg-open "$@"'';
                orphan = true;
                for = "unix";
              }
            ];
          };

          # refer: https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/yazi-default.toml#L61
          open.rules = [
            # Folder
            {
              name = "*/";
              use = [
                "edit"
                "open"
                "reveal"
              ];
            }

            # Text
            {
              mime = "text/*";
              use = [
                "edit"
                "reveal"
              ];
            }

            # Image
            {
              mime = "image/*";
              use = [
                "open"
                "reveal"
              ];
            }

            # Media
            {
              mime = "{audio,video}/*";
              use = [
                "play"
                "reveal"
              ];
            }

            # JSON
            {
              mime = "application/{json,ndjson}";
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

            # Empty file
            {
              mime = "inode/empty";
              use = [
                "edit"
                "reveal"
              ];
            }

            # Fallback
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

      {
        ## image preview
        extraPackages = [ pkgs.chafa ];
      }

      {
        # Archive
        extraPackages = [ pkgs.p7zip ];

        settings.open.rules = [
          {
            name = "*.{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
            use = [
              "extract"
              "reveal"
            ];
          }
        ];
      }

      {
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
      }

      # Plugins
      {
        plugins.mount = pkgs.yaziPlugins.mount;
        keymap.mgr.prepend_keymap = [
          {
            on = "M";
            run = "plugin mount";
          }
        ];
      }
      {
        plugins.jump-to-char = pkgs.yaziPlugins.jump-to-char;
        keymap.mgr.prepend_keymap = [
          {
            on = "f";
            run = "plugin jump-to-char";
            desc = "Jump to char";
          }
        ];
      }
    ];
  };
}

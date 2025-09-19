{
  my,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    trash-cli # trash

    # Archive
    gnutar
    unzip
    zip

    # yazi
    ## image
    chafa
    ueberzugpp
    ## archive
    p7zip
  ];

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
              run = ''${my.programs.editor} "$@"'';
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
              run = ''${my.programs.video} "$@"'';
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

          # Archive
          {
            name = "*.{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
            use = [
              "extract"
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

    # Plugins
    {
      plugins.mount = "${inputs.yazi-plugins}/mount.yazi";
      keymap.mgr.prepend_keymap = [
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
      keymap.mgr.prepend_keymap = [
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
      ];
    }
  ];
}

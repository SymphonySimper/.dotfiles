{
  my,
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  xdg-open = lib.getExe' pkgs.xdg-utils "xdg-open";
in
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

        preview = {
          max_width = my.gui.display.width / 2;
          max_height = my.gui.display.height / 2;
          ueberzug_scale = my.gui.display.scale / 2;
          # ueberzug_offset = [
          #   ((my.gui.display.scale * 10) + my.gui.display.scale) # x
          #   (my.gui.display.scale) # y
          #   0.0 # w
          #   0.0 # h
          # ];
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
              run = ''${xdg-open} "$@"'';
              desc = "Open";
              for = "linux";
            }
          ];

          reveal = [
            {
              run = ''${xdg-open} "$(dirname "$1")"'';
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
              run = ''${xdg-open} "$@"'';
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

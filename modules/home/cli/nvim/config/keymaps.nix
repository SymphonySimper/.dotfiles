{ config, lib, ... }:
let
  mkKeymaps =
    keymaps:
    map (keymap: {
      action = keymap.action;
      key = keymap.key;
      mode = keymap.mode;
      options = {
        desc = keymap.desc;
        silent = false;
      };
    }) keymaps;

in
{
  options.my.programs.nvim.keymaps = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          action = lib.mkOption {
            type = lib.types.oneOf [
              lib.types.str
              (lib.types.submodule {
                options.__raw = lib.mkOption {
                  type = lib.types.lines;
                  description = "Raw lua";
                };
              })
            ];
            description = "Command to run on keymap";
          };
          key = lib.mkOption {
            type = lib.types.str;
            description = "Keymap";
          };
          mode = lib.mkOption {
            type = lib.types.oneOf [
              (lib.types.listOf lib.types.str)
              lib.types.str
            ];
            description = "Modes where keymap should work";
            default = "n";
          };
          desc = lib.mkOption {
            type = lib.types.str;
            description = "Description of keymap";
            default = "";
          };
        };
      }
    );
    default = [ ];
    description = "Nvim keymaps";
  };

  config = {
    programs.nixvim = {
      globals = {
        mapleader = " ";
        maplocalleader = ",";
      };
      keymaps = mkKeymaps config.my.programs.nvim.keymaps;
    };

    my.programs.nvim.keymaps =
      [
        # General
        {
          action = ":noh<CR>";
          key = "<esc>";
          desc = "No highlight";
        }

        # Clipboard
        {
          action = "\"+y<CR>";
          key = "<leader>y";
          mode = [
            "n"
            "v"
          ];
          desc = "Copy to system clipboard";
        }
        {
          action = "\"+p<CR>";
          key = "<leader>p";
          mode = [
            "n"
            "v"
          ];
          desc = "Copy to system clipboard";
        }

        # File
        {
          action = ":w<CR>";
          key = "<leader>w";
          mode = [
            "n"
            "v"
          ];
          desc = "Write";
        }
        {
          action = ":bd<CR>";
          key = "<leader>bd";
          mode = [
            "n"
            "v"
          ];
          desc = "Close buffer";
        }
        {
          action = ":q<CR>";
          key = "<leader>q";
          mode = [
            "n"
            "v"
          ];
          desc = "Quit";
        }

      ]
      ++
      # Navigation
      (builtins.map
        (key: {
          action = "<C-w>${key}";
          key = "<C-${key}>";
          desc = "Focus ${key} pane";
        })
        [
          "h"
          "j"
          "k"
          "l"
        ]
      );
  };
}

{ lib, pkgs, ... }:
let
  formatter = {
    jq = lib.getExe pkgs.jq;
    xml = "${pkgs.libxml2}/bin/xmllint";
  };

  mkKeymaps =
    keymaps:
    lib.my.mkKeymaps (
      map (keymap: [
        { __raw = ''require('kulala').${builtins.elemAt keymap 0}''; }
        "<leader>r${builtins.elemAt keymap 1}"
        "n"
        (builtins.elemAt keymap 2)
      ]) keymaps
    );

in
{
  programs.nixvim = {
    plugins.kulala = {
      enable = true;

      settings.contenttypes = {

        "application/json" = {
          formatter = [
            formatter.jq
            "."
          ];
          ft = "json";
          pathresolver = {
            __raw = "require('kulala.parser.jsonpath').parse";
          };
        };
        "application/xml" = {
          formatter = [
            formatter.xml
            "--format"
            "-"
          ];
          ft = "xml";
          pathresolver = [
            formatter.xml
            "--xpath"
            "{{path}}"
            "-"
          ];
        };
        "text/html" = {
          formatter = [
            formatter.xml
            "--format"
            "--html"
            "-"
          ];
          ft = "html";
          pathresolver = [ ];
        };

      };
    };

    keymaps = (
      mkKeymaps [
        [
          "run"
          "r"
          "Run request under the cursor"
        ]
        [
          "replay"
          "l"
          "Re-run latest request"
        ]
        [
          "scratchpad"
          "S"
          "Kulala scratchpad"
        ]
        [
          "copy"
          "Y"
          "Copy as curl"
        ]
        [
          "from_curl"
          "P"
          "Paste from curl"
        ]
        [
          "inspect"
          "i"
          "Inspect current request"
        ]
        [
          "jump_prev"
          "p"
          "Jump to prev request"
        ]
        [
          "jump_next"
          "n"
          "Jump to next request"
        ]
        [
          "close"
          "q"
          "Close window"
        ]
        [
          "show_stats"
          "s"
          "Show stats"
        ]
        [
          "toggle_view"
          "t"
          "Toggle headers/body"
        ]
      ]
    );

    # for rest.nvim
    # extraFiles = {
    #   "ftplugin/json.lua".text = # lua
    #     ''
    #       vim.bo.formatexpr = ""
    #       vim.bo.formatprg = "${lib.getExe pkgs.jq}"
    #     '';
    # };
  };
}

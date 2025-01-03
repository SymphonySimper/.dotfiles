{
  config,
  pkgs,
  lib,
  ...
}:
let
  timeout = 3000;

  mkFormatter = package: {
    command = if builtins.typeOf package == "set" then "${lib.getExe package}" else package;
  };
in
{
  options.programs.nixvim.plugins.conform-nvim.formatter = lib.mkOption {
    description = "Set `formatters` in conform";
    type = lib.types.attrsOf (
      lib.types.oneOf [
        lib.types.str
        lib.types.package
      ]
    );
    default = { };
  };

  config = {
    programs.nixvim = {
      plugins.conform-nvim = {
        enable = true;
        settings = {
          log_level = "error";
          notify_on_error = true;
          notify_no_formatters = false;
          default_format_opts = {
            lsp_format = "fallback";
            async = false;
            quiet = false;
            stop_after_first = false;
            timeout_ms = timeout;
          };
          format_on_save = null;
          format_after_save = null;
          formatters_by_ft = {
            # "*" = [ "injected" ];
          };
          formatters =
            {
              injected = {
                options = {
                  ignore_errors = true;
                };
              };
              prettier = mkFormatter pkgs.nodePackages.prettier;
            }
            // (builtins.mapAttrs (
              name: value: mkFormatter value
            ) config.programs.nixvim.plugins.conform-nvim.formatter);
        };
      };

      keymaps = lib.my.mkKeymaps [
        [
          {
            __raw = # lua
              ''
                function()
                  require("conform").format()
                  vim.cmd("write")
                end
              '';
          }
          "<leader>cf"
          [
            "n"
            "v"
          ]
          "Format and save"
        ]
        [
          {
            __raw = # lua
              ''
                function()
                  require("conform").format({ formatters = { "injected" }, timeout_ms = "${toString timeout}"})
                end
              '';
          }
          "<leader>cF"
          [
            "n"
            "v"
          ]
          "Format Injected Langs"
        ]
      ];
    };
  };
}

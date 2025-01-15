{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.nixvim.plugins.formatter;
  timeout = 3000;
in
{
  options.programs.nixvim.plugins.formatter = {
    packages = lib.mkOption {
      type = lib.types.listOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.package

          (lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Name of formatter as per conform.nvim";
              };
              package = lib.mkOption {
                type = lib.types.oneOf [
                  lib.types.str
                  lib.types.package
                ];
                description = "Package to be used";
              };
            };
          })
        ]
      );
      description = "Nixvim formatters for conform";
      default = [ ];
    };

    ft = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          (lib.types.listOf lib.types.str)
          lib.types.str
        ]
      );
      description = "Formatter to be used for the filetype";
      default = { };
    };
  };

  config.programs.nixvim = {
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
        formatters_by_ft = builtins.mapAttrs (
          name: value: if builtins.typeOf value == "string" then [ value ] else value
        ) cfg.ft;
        formatters =
          {
            injected = {
              options = {
                ignore_errors = true;
              };
            };
          }
          // (builtins.listToAttrs (
            builtins.map (
              formatter:
              let
                isString = builtins.typeOf formatter == "string";
                isPackage = if isString then false else (builtins.hasAttr "out" formatter);
                package =
                  if isString then
                    pkgs.${formatter}
                  else if isPackage then
                    formatter
                  else
                    formatter.package;
              in
              {
                name =
                  if (isString || isPackage) then
                    (if builtins.hasAttr "packageName" package then package.packageName else package.pname)
                  else
                    formatter.name;
                value = {
                  command = if builtins.typeOf package == "string" then package else "${lib.getExe package}";
                };
              }
            ) cfg.packages
          ));
      };
    };

    keymaps = [
      {
        action.__raw = ''
          function()
            require("conform").format()
            vim.cmd("write")
          end
        '';
        key = "<leader>cf";
        mode = [
          "n"
          "v"
        ];
        options.desc = "Format and save";
      }
      {
        action.__raw = ''
          function()
            require("conform").format({ formatters = { "injected" }, timeout_ms = "${toString timeout}"})
          end
        '';
        key = "<leader>cF";
        mode = [
          "n"
          "v"
        ];
        options.desc = "Format Injected Langs";
      }
    ];
  };
}

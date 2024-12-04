{ lib, pkgs, ... }:
let
  timeout = 3000;

  mkFormatter = package: {
    command = if builtins.typeOf package == "set" then "${lib.getExe package}" else package;
  };
in
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = true;
        notify_no_formatters = false;
        default_format_opts = {
          lsp_format = "fallback";
          async = false;
          quiet = false;
          stop_after_first = true;
          timeout_ms = timeout;
        };
        format_on_save = null;
        format_after_save = null;
        formatters_by_ft = rec {
          nix = [ "nixfmt" ];
          sh = [ "shfmt" ];
          lua = [ "stylua" ];
          python = [ "ruff_format" ];

          javascript = [ "prettier" ];
          typescript = javascript;
          svelte = javascript;
          css = javascript;
          html = javascript;
          markdown = javascript;

          json = ["biome"];
          jsonc = json;

          go = [
            "gofmt"
            "goimports"
          ];
          templ = [ "gofmt" ];

          http = [ "kulala" ];
          rest = http;

          just = [ "just" ];
        };
        formatters = {
          injected = {
            options = {
              ignore_errors = true;
            };
          };
          prettier = mkFormatter pkgs.nodePackages.prettier;
          nixfmt = mkFormatter pkgs.nixfmt-rfc-style;
          shfmt = mkFormatter pkgs.shfmt;
          stylua = mkFormatter pkgs.stylua;
          goimports = mkFormatter "${pkgs.gotools}/bin/goimports";
          biome = mkFormatter pkgs.biome;
          kulala = mkFormatter pkgs.kulala-fmt // {
            args = [
              "$FILENAME"
            ];
            stdin = false;
          };
          just = mkFormatter pkgs.just;
        };
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
}

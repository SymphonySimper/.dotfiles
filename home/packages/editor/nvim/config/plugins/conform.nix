{ lib, pkgs, ... }:
let
  prettier = [ "prettier" ];
  biome = [ "biome" ];
  timeout = 3000;

  mkFormatter = package: {
    command = "${lib.getExe package}";
  };
in
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = false;
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = timeout;
        };
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          sh = [ "shfmt" ];
          lua = [ "stylua" ];
          python = [ "ruff_format" ];
          javascript = biome;
          typescript = biome;
          json = biome;
          jsonc = biome;
          svelte = prettier;
          css = prettier;
          html = prettier;
          markdown = prettier;
        };
        formatters = {
          biome = mkFormatter pkgs.biome;
          nixfmt = mkFormatter pkgs.nixfmt-rfc-style;
          prettier = mkFormatter pkgs.nodePackages.prettier;
          shfmt = mkFormatter pkgs.shfmt;
          stylua = mkFormatter pkgs.stylua;
        };
      };
    };

    keymaps = lib.my.mkKeymaps [
      [
        {
          __raw = # lua
            ''
              function()
                require("conform").format({ formatters = { "injected" }, timeout_ms = ${toString timeout}})
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

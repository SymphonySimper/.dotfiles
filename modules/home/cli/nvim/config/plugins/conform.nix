{ lib, pkgs, ... }:
let
  prettier = [ "prettier" ];
  biome = [ "biome" ];
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
          javascript = prettier;
          typescript = prettier;
          svelte = prettier;
          css = prettier;
          html = prettier;
          markdown = prettier;
          json = biome;
          jsonc = biome;
          go = [
            "gofmt"
            "goimports"
          ];
          templ = [ "gofmt" ];
          http = [ "kulala" ];
          rest = [ "kulala" ];
        };
        formatters = {
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

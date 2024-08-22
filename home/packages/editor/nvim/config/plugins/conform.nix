{ myUtils, pkgs, ... }:
let
  web = [ "prettier" ];
  timeout = 3000;
in
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      notifyOnError = false;
      formatOnSave = {
        lspFallback = true;
        timeoutMs = timeout;
      };
      formattersByFt = {
        nix = [ "nixfmt" ];
        sh = [ "shfmt" ];
        lua = [ "stylua" ];
        python = [ "ruff_format" ];
        javascript = web;
        typescript = web;
        svelte = web;
        css = web;
        html = web;
        json = web;
        "*" = [
          "codespell"
          "trim_whitespace"
        ];
      };
      formatters = {
        injected = {
          options = {
            ignore_errors = true;
          };
        };
      };
    };

    extraPackages = with pkgs; [
      nixfmt-rfc-style
      shfmt
      stylua
      nodePackages.prettier
      codespell
      gawk # trim_whitespace
    ];

    keymaps = myUtils.mkKeymaps [
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

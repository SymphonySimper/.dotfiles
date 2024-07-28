{ pkgs, ... }:
let
  web = [ "prettier" ];
in
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      notifyOnError = false;
      formatOnSave = {
        lspFallback = true;
        timeoutMs = 500;
      };
      formattersByFt = {
        nix = [ "nixfmt" ];
        lua = [ "stylua" ];
        python = [ "ruff" ];
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
    };

    extraPackages = with pkgs; [
      nixfmt-rfc-style
      stylua
      nodePackages.prettier
      codespell
      gawk # trim_whitespace
    ];
  };
}

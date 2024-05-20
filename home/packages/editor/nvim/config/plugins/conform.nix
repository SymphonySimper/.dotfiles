{ ... }:
let
  web = [ [ "prettierd" "prettier" ] ];
in
{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    formatOnSave = {
      lspFallback = true;
      timeoutMs = 500;
    };
    formattersByFt = {
      javascript = web;
      typescript = web;
      svelte = web;
      css = web;
      html = web;
      json = web;
    };
  };
}

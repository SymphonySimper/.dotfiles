{ pkgs, ... }:
let
  web = [ [ "prettierd" "prettier" ] ];
in
{
  home.packages = with pkgs; [
    prettierd
    nodePackages.prettier
  ];

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

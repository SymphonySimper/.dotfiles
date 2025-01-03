{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "bash" ];

    conform-nvim = {
      formatter.shfmt = pkgs.shfmt;
      settings.formatters_by_ft.sh = [ "shfmt" ];
    };

    lsp.servers.bashls.enable = true;
  };
}

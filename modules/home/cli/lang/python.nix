{ ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "python" ];

    lsp.servers = {
      pyright.enable = true;
      ruff.enable = true;
    };

    formatter.ft.python = "ruff_format";
  };
}

{ ... }:
{
  my.programs.nvim = {
    treesitter = [ "bash" ];
    lsp.bashls.enable = true;
    formatter = {
      packages = [ "shfmt" ];
      ft.sh = "shfmt";
    };
  };
}

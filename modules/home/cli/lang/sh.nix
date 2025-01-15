{ ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "bash" ];
    lsp.servers.bashls.enable = true;
    formatter = {
      packages = [ "shfmt" ];
      ft.sh = "shfmt";
    };
  };
}

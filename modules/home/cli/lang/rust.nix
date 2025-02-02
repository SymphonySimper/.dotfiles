{ ... }:
{
  programs.helix = {
    grammars = [ "rust" ];
    lsp.rust-analyzer.config.check = "clippy";
  };
}

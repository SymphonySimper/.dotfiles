{ ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "rust" ];

    lsp.servers.rust_analyzer = {
      enable = true;
      installCargo = false;
      installRustc = false;
      settings = {
        checkOnSave = true;
        check.command = "clippy";
      };
    };
  };

  programs.helix = {
    grammars = [ "rust" ];
    lsp.rust-analyzer.config.check = "clippy";
  };
}

{ pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      rustup
      sccache
    ];

    shellAliases = {
      rc = "cargo";
      rcn = "cargo new";
      rca = "cargo add";
      rcr = "cargo run";
      rct = "cargo test";
    };
  };

  programs.nixvim.plugins = {
    treesitter.grammars = [ "rust" ];

    lsp.servers.rust_analyzer = {
      enable = true;
      installCargo = false;
      installRustc = false;
      settings = {
        checkOnSave = true;
        check = {
          command = "clippy";
        };
      };
    };
  };
}

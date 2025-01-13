{ pkgs, ... }:
{
  my = {
    home = {
      packages = with pkgs; [
        rustup
        sccache
      ];

      shell.aliases = {
        rc = "cargo";
        rcn = "cargo new";
        rca = "cargo add";
        rcr = "cargo run";
        rct = "cargo test";
      };
    };

    programs.nvim = {
      treesitter = [ "rust" ];

      lsp.rust_analyzer = {
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
  };
}

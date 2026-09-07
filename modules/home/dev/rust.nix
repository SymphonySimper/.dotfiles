{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.rust = {
    enable = lib.mkEnableOption "Rust";
  };

  config = lib.mkIf config.dev.rust.enable {
    home.packages = [
      pkgs.rustc
      pkgs.cargo
      pkgs.rustfmt
      pkgs.clippy

      pkgs.gcc
    ];

    home.sessionVariables.RUST_BACKTRACE = "1";

    programs.neovim = {
      extraPackages = [ pkgs.rust-analyzer ];

      config = {
        conform = ''
          conform.formatters_by_ft.rust = { "rustfmt" } 
        '';

        lsp = ''
          vim.lsp.config("rust_analyzer", {
            settings = { check = { command = "clippy" } }
          })
          vim.lsp.enable("rust_analyzer") 
        '';
      };
    };
  };
}

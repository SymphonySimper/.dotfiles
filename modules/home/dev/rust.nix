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

    programs.nixvim = {
      lsp.servers.rust_analyzer = {
        enable = true;
        config.settings.rust-analyzer.check.command = "clippy";
      };

      plugins.conform-nvim.formatters.rust = ["rustfmt"];
      plugins.treesitter.grammars = ["rust"];
    };
  };
}

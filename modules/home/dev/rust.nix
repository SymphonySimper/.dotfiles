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

    programs.helix = {
      lsp.rust-analyzer = {
        command = lib.getExe pkgs.rust-analyzer;
        config.check.command = "clippy";
      };
    };
  };
}

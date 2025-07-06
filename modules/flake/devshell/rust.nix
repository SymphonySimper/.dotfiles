{ pkgs, ... }:
{
  packages = with pkgs; [
    rustup
    sccache
  ];

  env = {
    RUST_BACKTRACE = "1";
  };
}

{ pkgs, ... }:
{
  packages = with pkgs; [
    rustup
    sccache
  ];

  env = {
    RUST_BACKTRACE = "1";
  };

  shellHook = # sh
    ''
      alias rc="cargo"
      alias rcn="cargo new"
      alias rca="cargo add"
      alias rcr="cargo run"
      alias rct="cargo test"
    '';
}

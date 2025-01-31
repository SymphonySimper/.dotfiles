{ pkgs, ... }: {
  packages = with pkgs; [
    rustup
    sccache
  ];

  shellHook = # sh
    ''
      export RUST_BACKTRACE="1"

      alias rc="cargo"
      alias rcn="cargo new"
      alias rca="cargo add"
      alias rcr="cargo run"
      alias rct="cargo test"
    '';
}

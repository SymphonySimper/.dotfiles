{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup
    sccache
  ];

  home.shellAliases = {
    ## rust
    rc = "cargo";
    rcn = "cargo new";
    rca = "cargo add";
    rcr = "cargo run";
    rct = "cargo test";
  };
}

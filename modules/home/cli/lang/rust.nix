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
}

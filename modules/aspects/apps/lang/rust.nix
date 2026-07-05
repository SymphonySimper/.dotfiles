{
  den.aspects.apps.lang.rust = {
    homeManager =
      { pkgs, lib, ... }:
      let
        rustup = pkgs.rustup;
      in
      {
        home.packages = [
          rustup
          pkgs.sccache
          pkgs.gcc
        ];

        home.sessionVariables.RUST_BACKTRACE = "1";

        programs.helix.languages = {
          language-server.rust-analyzer = {
            command = lib.getExe' rustup "rust-analyzer";
            config.check = "clippy";
          };
        };
      };
  };
}

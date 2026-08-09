{
  den.aspects.apps.lang.nix = {
    homeManager = { pkgs, lib, ... }: {
      programs.helix = {
        lsp.nixd = {
          command = lib.getExe pkgs.nixd;
          args = [ "--inlay-hints=false" ];
          config.nixd = {
            nixpkgs.expr = "import <nixpkgs> { }";
          };
        };

        lang.nix = {
          formatter.command = lib.getExe pkgs.nixfmt;
          language-servers = [
            {
              name = "nixd";
              except-features = [ "format" ];
            }
          ];
        };
      };
    };
  };
}

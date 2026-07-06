{ pkgs, lib, ... }: {
  my.programs.editor = {
    lsp.nixd = {
      command = lib.getExe pkgs.nixd;
      args = [ "--inlay-hints=false" ];
      config.nixd = {
        nixpkgs.expr = "import <nixpkgs> { }";
      };
    };

    language.nix = {
      formatter.command = lib.getExe pkgs.nixfmt;

      language-servers = [
        {
          name = "nixd";
          except-features = [ "format" ];
        }
      ];
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.dev.nix = {
    enable = lib.mkEnableOption "Nix";
  };

  config = lib.mkIf config.dev.nix.enable {
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
}

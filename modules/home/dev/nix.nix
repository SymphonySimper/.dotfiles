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
    programs.neovim = {
      extraPackages = [ pkgs.nixd ];
      treeSitter.packages = [ "nix" ];

      lsp = ''
        vim.lsp.enable('nixd');
        vim.lsp.config('nixd', {
           settings = {
             nixd = {
               nixpkgs = {
                 expr = "import <nixpkgs> { }"
               },
             },
           },
        });
      '';
    };

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

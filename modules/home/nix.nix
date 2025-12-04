{ my, pkgs, ... }:
{
  my.programs.editor = {
    packages = [
      pkgs.nixd
      pkgs.nixfmt
    ];

    lsp.nixd = {
      args = [ "--inlay-hints=false" ];
      config.nixd = {
        nixpkgs.expr = "import <nixpkgs> { }";

        options = {
          nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${my.profile}.options";
          home-manager.expr = "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.${my.profile}.options";
        };
      };
    };

    language.nix = {
      formatter.command = "nixfmt";

      language-servers = [
        {
          name = "nixd";
          except-features = [ "format" ];
        }
      ];
    };
  };
}

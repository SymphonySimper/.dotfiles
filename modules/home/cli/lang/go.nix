{ pkgs, ... }:
{
  home.packages = [ pkgs.templ ];

  programs = {
    go.enable = true;

    nixvim.plugins = {
      treesitter.grammars = [
        "go"
        "gomod"
        "gowork"
        "gosum"
        "templ"
      ];

      lsp.servers = {
        gopls = {
          enable = true;
          settings = {
            gopls = {
              completeUnimported = true;
            };
          };
        };
        templ.enable = true;
      };

      formatter = {
        packages = [
          {
            name = "goimports";
            package = "${pkgs.gotools}/bin/goimports";
          }
        ];

        ft = {
          go = [
            "gofmt"
            "goimports"
          ];
          templ = "gofmt";
        };
      };
    };
  };
}

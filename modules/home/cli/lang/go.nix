{ pkgs, ... }:
{
  programs.go.enable = true;
  my = {
    home.packages = [ pkgs.templ ];

    programs.nvim = {
      treesitter = [
        "go"
        "gomod"
        "gowork"
        "gosum"
        "templ"
      ];

      lsp = {
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

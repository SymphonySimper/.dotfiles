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

      conform-nvim = {
        formatter = {
          goimports = "${pkgs.gotools}/bin/goimports";
        };
        settings.formatters_by_ft = {
          go = [
            "gofmt"
            "goimports"
          ];
          templ = [ "gofmt" ];
        };
      };

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
    };
  };
}

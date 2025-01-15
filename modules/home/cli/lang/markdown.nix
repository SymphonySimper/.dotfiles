{ pkgs, ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "markdown" ];

    lsp.servers.marksman.enable = true;

    formatter = {
      packages = [ pkgs.nodePackages.prettier ];
      ft.markdown = "prettier";
    };

    markview = {
      enable = true;
      settings = {
        modes = [
          "n"
          "no"
          "c"
        ];

        list_items = {
          shift_width = 2;
        };

        hybrid_modes = [ "n" ];
        callbacks = {
          on_enable.__raw = # lua
            ''
              function (_, win)
                 vim.wo[win].conceallevel = 2;
                 vim.wo[win].concealcursor = "c";
               end
            '';
        };
      };
    };
  };
}

{ ... }:
{
  programs.nixvim.plugins = {
    treesitter.grammars = [ "markdown" ];

    conform-nvim.settings.formatters_by_ft.markdown = [ "prettier" ];

    lsp.servers.marksman.enable = true;

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

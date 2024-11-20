{ ... }:
{
  programs.nixvim.plugins = {
    # cmp
    cmp-nvim-lsp.enable = true;
    cmp-path.enable = true;
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        preselect = "cmp.PreselectMode.None";
        sources = [
          { name = "nvim_lsp"; }
          { name = "path"; }
        ];
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
          "<C-p>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.abort()";
          "<C-y>" = "cmp.mapping.confirm({ select = true })";
        };

        performance = {
          max_view_entries = 8;
        };
      };
    };
  };
}

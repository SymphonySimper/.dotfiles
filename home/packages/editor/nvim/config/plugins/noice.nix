{ ... }:
let
  view = "mini";
in
{
  programs.nixvim.plugins = {
    noice = {
      enable = true;
      presets = {
        bottom_search = false;
        command_palette = false;
      };
      redirect.view = "popup";
      messages = {
        inherit view;
        viewError = view;
        viewWarn = view;
      };
      notify.view = view;
      lsp = {
        message.view = view;
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
      };
    };
    dressing.enable = true;
  };
}

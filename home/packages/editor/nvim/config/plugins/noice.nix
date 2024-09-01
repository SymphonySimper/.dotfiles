{ ... }:
{
  programs.nixvim.plugins = {
    noice = {
      enable = true;
      messages.view = "mini";
      notify.view = "mini";
      lsp.override = {
        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        "vim.lsp.util.stylize_markdown" = true;
        "cmp.entry.get_documentation" = true;
      };
    };
  };
}

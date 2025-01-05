{ ... }:
{
  programs.nixvim.plugins = {
    friendly-snippets.enable = true;
    blink-cmp = {
      enable = true;
      settings = {
        appearance.nerd_font_variant = "mono";
        keymap.preset = "default";
        completion.list.max_items = 20;
      };
    };
  };
}

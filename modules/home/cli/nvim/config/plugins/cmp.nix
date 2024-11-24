{ ... }:
{
  programs.nixvim.plugins = {
    friendly-snippets.enable = true;
    blink-cmp = {
      enable = true;
      settings = {
        nerd_font_variant = "mono";
        keymap.preset = "default";
        fuzzy.max_items = 20;
      };
    };
  };
}

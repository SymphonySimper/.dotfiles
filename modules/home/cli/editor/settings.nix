{ my, ... }:
{
  programs.helix.settings = {
    editor = {
      line-number = "relative";
      auto-format = false;
      bufferline = "never";
      auto-pairs = true;
      true-color = my.profile == "wsl";
      indent-guides.render = false;
      soft-wrap.enable = true;

      cursor-shape = rec {
        normal = "block";
        insert = "bar";
        select = normal;
      };

      end-of-line-diagnostics = "hint";
      inline-diagnostics.cursor-line = "warning";
      lsp = {
        enable = true;
        display-inlay-hints = false;
        auto-signature-help = false;
      };
    };
  };
}

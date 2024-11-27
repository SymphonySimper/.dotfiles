{ ... }:
{
  programs.nixvim = {
    autoGroups = {
      "my-highlight-yank" = {
        clear = true;
      };
    };
    autoCmd = [
      {
        # Highlight when yanking (copying) text
        event = "TextYankPost";
        group = "my-highlight-yank";
        callback = {
          __raw =
            # lua
            ''
              function()
                vim.highlight.on_yank()
              end
            '';
        };
      }
    ];
  };
}

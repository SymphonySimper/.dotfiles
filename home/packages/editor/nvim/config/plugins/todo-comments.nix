{ myUtils, ... }:
{
  programs.nixvim = {
    plugins.todo-comments = {
      enable = true;
      keymaps = {
        todoLocList = {
          action = "TodoLocList";
          key = "<leader>tl";
          mode = "n";
          options.desc = "Show Todo Location List";
        };
      };
    };
    keymaps = myUtils.mkKeymaps [
      [
        { __raw = ''function() require("todo-comments").jump_next() end''; }
        "]t"
        "n"
        "Next Todo Comment"
      ]
      [
        { __raw = ''function() require("todo-comments").jump_prev() end''; }
        "[t"
        "n"
        "Previous Todo Comment"
      ]
    ];
  };
}

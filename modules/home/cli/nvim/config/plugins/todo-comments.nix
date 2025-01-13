{ ... }:
{
  programs.nixvim.plugins.todo-comments = {
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

  my.programs.nvim.keymaps = [
    {
      action.__raw = ''function() require("todo-comments").jump_next() end'';
      key = "]t";
      desc = "Next Todo Comment";
    }
    {
      action.__raw = ''function() require("todo-comments").jump_prev() end'';
      key = "[t";
      desc = "Previous Todo Comment";
    }
  ];
}

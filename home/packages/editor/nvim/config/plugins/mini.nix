{ myUtils, ... }:
{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
        pairs = { };
        move = { };
        bracketed = { };
        indentscope = {
          symbol = "│";
          options = {
            try_as_border = true;
          };
        };
        files = { };
      };
    };
    keymaps = (
      myUtils.mkKeymaps [
        [
          {
            __raw = ''
              function()
              	require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
              end
            '';
          }
          "<leader>fm"
          "n"
          "Open mini.files (Directory of Current File)"
        ]
        [
          {
            __raw = ''
              function()
              	require("mini.files").open(vim.uv.cwd(), true)
              end
            '';
          }
          "<leader>fM"
          "n"
          "Open mini.files (cwd)"
        ]
      ]
    );
  };
}

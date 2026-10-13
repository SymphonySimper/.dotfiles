{ ... }: {
  programs.nixvim = {
    plugins.mini-diff = {
      enable = true;
      settings.view.style = "number";
    };

    plugins.mini-files = {
      enable = true;
      settings.windows.max_number = 3;
    };

    plugins.mini-pairs.enable = true;

    plugins.mini-surround = {
      enable = true;

      settings.mappings = {
        add = "gsa";
        delete = "gsd";
        find = "gsf";
        find_left = "gsF";
        highlight = "gsh";
        replace = "gsr";
      };
    };

    keymaps = [
      # mini-files
      {
        action.__raw = ''
          function()
            require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
          end
        '';
        key = "<leader>fm";
        mode = "n";
        options.desc = "Open mini.files (Directory of Current File)";
      }
      {
        action.__raw = ''
          function()
            require("mini.files").open(vim.uv.cwd(), true)
          end
        '';
        key = "<leader>fM";
        mode = "n";
        options.desc = "Open mini.files (cwd)";
      }
    ];
  };
}

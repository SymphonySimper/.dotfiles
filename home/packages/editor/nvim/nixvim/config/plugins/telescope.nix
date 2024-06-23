{ myUtils, ... }: {
  programs.nixvim = {
    plugins.telescope = {
      enable = true;

      extensions = {
        fzf-native = {
          enable = true;
          settings = {
            case_mode = "smart_case";
          };
        };
      };

      keymaps = {
        "<leader>F" = {
          action = "find_files";
          options.desc = "Telescope find_files";
          mode = [ "n" "v" ];
        };
        "<leader><space>" = {
          action = "buffers";
          options.desc = "Telescope find buffer";
          mode = [ "n" "v" ];
        };
        "<leader>sg" = {
          action = "live_grep";
          options.desc = "Telescope find string";
          mode = [ "n" "v" ];
        };
      };
    };

    keymaps = myUtils.mkKeymaps [
      [{ __raw = "function() require('telescope.builtin').find_files({ cwd = vim.fn.expand('%:p:h') }) end"; } "<leader>f" "n" "Find files from current file"]
    ];
  };
}

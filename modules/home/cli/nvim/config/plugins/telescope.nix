{ ... }:
let
  mkActionKeyMaps =
    actionMaps:
    map (
      actionMap:
      let
        require = "require('telescope.builtin').${builtins.elemAt actionMap 0}";
        cwd = builtins.elemAt actionMap 1;
        key = builtins.elemAt actionMap 2;
        desc = builtins.elemAt actionMap 3;
      in
      {
        inherit key;
        action.__raw =
          if cwd == "root" then # lua
            ''
              function()
              	local function is_git_repo()
              		vim.fn.system("git rev-parse --is-inside-work-tree")

              		return vim.v.shell_error == 0
              	end

              	local function get_git_root()
              		local dot_git_path = vim.fn.finddir(".git", ".;")
              		return vim.fn.fnamemodify(dot_git_path, ":h")
              	end

              	local opts = {}

              	if is_git_repo() then
              		opts = {
              			cwd = get_git_root(),
              		}
              	end

              	${require}(opts)
              end
            ''
          else if cwd == "buffer" then # lua
            "function() ${require}({ cwd = vim.fn.expand('%:p:h') }) end"
          else
            # lua
            "function() ${require}() end";
        mode = [
          "n"
          "v"
        ];
        options.desc = desc;
      }
    ) actionMaps;
in
{
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

      settings = {
        defaults = {
          layout_config = {
            prompt_position = "top";
          };
          sorting_strategy = "ascending";
          file_ignore_patterns = [
            "^.git/"
            "^node_modules/"
            "^build/"
            "^.mypy_cache/"
            "^__pycache__/"
            "^output/"
            "^data/"
            "%.ipynb"
          ];
        };
      };
    };

    keymaps = (
      mkActionKeyMaps [
        # Find Files
        [
          "find_files"
          "root"
          "<leader>fF"
          "Telescope find_files"
        ]
        [
          "find_files"
          ""
          "<leader>ff"
          "Telescope find_files"
        ]
        [
          "find_files"
          "buffer"
          "<leader>fc"
          "Find files from current file"
        ]

        # Buffers
        [
          "buffers"
          ""
          "<leader><space>"
          "Telescope find buffer"
        ]

        # Live grep
        [
          "live_grep"
          "root"
          "<leader>sg"
          "Telescope find string (Root)"
        ]
        [
          "live_grep"
          "buffer"
          "<leader>sG"
          "Telescope find string"
        ]
      ]
    );
  };
}

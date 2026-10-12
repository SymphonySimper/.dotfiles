{ ... }: {
  programs.nixvim = {
    plugins.fzf-lua = {
      enable = true;
      profile = "max-perf";

      settings = {
        ui_select = { };

        prompt = "> ";

        winopts = {
          backdrop = 0;
          fullscreen = true;
          title_pos = "left";

          preview = {
            title = false;
            default = "cat";
          };
        };

        files.cwd_prompt = false;

        keymap.fzf = {
          change = "top"; # reset to top on change

          # Scroll half-page down / up
          "ctrl-j" = "preview-half-page-down";
          "ctrl-k" = "preview-half-page-up";

          # Scroll single lines
          "ctrl-d" = "preview-down";
          "ctrl-u" = "preview-up";

          # Reset preview position back to top
          "ctrl-r" = "preview-top";
        };
      };

      # set border color to line number color
      luaConfig.post = ''
        vim.api.nvim_set_hl(0, "FzfLuaBorder", {
          link = "LineNr",
        })
      '';
    };

    keymaps =
      let
        fzf = "require(\"fzf-lua\")";
      in
      map
        (
          keymap:
          keymap
          // {
            mode = [
              "n"
              "v"
            ];
            options.silent = true;
          }
        )
        [
          {
            action.__raw = "${fzf}.resume";
            key = "<leader>f'";
            options.desc = "FZF Resume last picker";
          }

          {
            action.__raw = "${fzf}.files";
            key = "<leader>ff";
            options.desc = "FZF Find Files";
          }
          {
            action.__raw = ''
              function()
                local dir = vim.fn.expand("%:p:h")

                ${fzf}.files({
                  cwd = dir ~= "" and dir or vim.loop.cwd(),
                })
              end
            '';
            key = "<leader>fF";
            options.desc = "FZF find files in current buffere directory";
          }

          {
            action.__raw = "${fzf}.live_grep";
            key = "<leader>f/";
            options.desc = "FZF Live Grep";
          }
          {
            action.__raw = "${fzf}.git_status";
            key = "<leader>fg";
            options.desc = "FZF Git Status";
          }
          {
            action.__raw = "${fzf}.buffers";
            key = "<leader>fb";
            options.desc = "FZF Buffers";
          }
        ];
  };
}

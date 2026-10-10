{ ... }: {
  programs.nixvim = {
    plugins.fzf-lua = {
      enable = true;

      settings = {
        ui_select = { };

        prompt = "> ";

        winopts = {
          backdrop = 0;
          fullscreen = true;
          title_pos = "left";
          preview.title = false;
        };

        files.cwd_prompt = false;

        keymap.builtin = {
          # Scroll half-page down / up
          "<C-j>" = "preview-page-down";
          "<C-k>" = "preview-page-up";

          # Scroll single lines
          "<C-d>" = "preview-down";
          "<C-u>" = "preview-up";

          # Reset preview position back to top
          "<C-r>" = "preview-reset";
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

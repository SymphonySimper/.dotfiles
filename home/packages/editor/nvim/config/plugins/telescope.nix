{ ... }: {
  programs.nixvim.plugins.telescope = {
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
      "<leader>f" = {
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
}

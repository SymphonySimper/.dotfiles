{ ... }: {
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings = {
        default_file_explorer = true;
        delete_to_trash = true;
      };
    };

    keymaps = [
      {
        action = "<CMD>Oil<CR>";
        key = "<leader>e";
        mode = "n";
        options = {
          desc = "Open Parent directory";
        };
      }
    ];
  };
}

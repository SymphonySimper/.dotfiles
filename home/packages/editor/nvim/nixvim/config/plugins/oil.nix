{ myUtils, ... }: {
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings = {
        default_file_explorer = true;
        delete_to_trash = true;
        keymaps = {
          "<leader>e" = "actions.close";
        };
      };
    };

    keymaps = myUtils.mkKeymaps [
      [ "<CMD>Oil<CR>" "<leader>e" "n" "Open Parent directory" ]
    ];
  };
}

{ ... }: {
  programs.nixvim.plugins.telescope = {
    enable = true;
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
    };
  };
}

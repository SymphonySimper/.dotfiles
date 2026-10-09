{ ... }: {
  programs.nixvim = {
    plugins.conform-nvim.enable = true;

    keymaps = [
      {
        action = ''require("conform").format'';
        key = "<leader>cf";
        mode = [ "n" ];

        options = {
          silent = true;
          desc = "Format file";
        };
      }
    ];
  };
}

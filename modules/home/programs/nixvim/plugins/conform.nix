{ ... }: {
  programs.nixvim = {
    plugins.conform-nvim.enable = true;

    keymaps = [
      {
        action.__raw = "require(\"conform\").format";
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

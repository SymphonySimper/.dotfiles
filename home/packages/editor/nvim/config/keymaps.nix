{ ... }: {
  programs.nixvim.keymaps = [
    {
      action = "\"+y<CR>";
      key = "<leader>y";
      mode = [ "n" "v" ];
      options = {
        desc = "Copy to system clipboard";
      };
    }
    {
      action = "\"+p<CR>";
      key = "<leader>p";
      mode = [ "n" "v" ];
      options = {
        desc = "Copy to system clipboard";
      };
    }
    {
      action = ":w<CR>";
      key = "<leader>w";
      mode = [ "n" "v" ];
      options = {
        desc = "Write";
      };
    }
    {
      action = ":wa<CR>";
      key = "<leader>W";
      mode = [ "n" "v" ];
      options = {
        desc = "Write all";
      };
    }
    {
      action = ":bd<CR>";
      key = "<leader>bd";
      mode = [ "n" "v" ];
      options = {
        desc = "Close buffer";
      };
    }
    {
      action = ":q<CR>";
      key = "<leader>q";
      mode = [ "n" "v" ];
      options = {
        desc = "Quit";
      };
    }
    {
      action = ":qa<CR>";
      key = "<leader>Q";
      mode = [ "n" "v" ];
      options = {
        desc = "Quit all";
      };
    }
  ];
}

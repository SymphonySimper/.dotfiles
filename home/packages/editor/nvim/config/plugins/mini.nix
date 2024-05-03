{ ... }: {
  programs.nixvim.plugins.mini = {
    enable = true;
    modules = {
      surround = {
        mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };
      };
      comment = { };
      pairs = { };
      move = { };
      indentscope = {
        symbol = "│";
        options = { try_as_border = true; };
      };
    };
  };
}

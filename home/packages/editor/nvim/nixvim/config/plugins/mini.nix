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
      comment = {
        options = {
          custom_commentstring.__raw = ''
            function()
                  return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
            end
          '';
        };
      };
      pairs = { };
      move = { };
      bracketed = { };
      indentscope = {
        symbol = "│";
        options = { try_as_border = true; };
      };
    };
  };
}

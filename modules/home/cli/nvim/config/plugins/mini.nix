{ ... }:
{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      mockDevIcons = true;

      modules = {
        icons = { };

        surround.mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
          update_n_lines = "gsn";
        };

        pairs = { };

        move = { };

        bracketed = { };

        indentscope = {
          symbol = "│";
          options.try_as_border = true;
        };
      };
    };
  };
}

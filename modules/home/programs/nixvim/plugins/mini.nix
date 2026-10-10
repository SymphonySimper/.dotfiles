{ ... }: {
  programs.nixvim = {
    plugins.mini = {
      enable = true;

      modules = {
        files = { };
        pairs = { };

        surround.mappings = {
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";
        };
      };
    };
  };
}

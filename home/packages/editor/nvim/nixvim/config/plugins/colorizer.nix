{ ... }: {
  programs.nixvim.plugins.nvim-colorizer = {
    enable = true;
    userDefaultOptions.tailwind = true;
  };
}

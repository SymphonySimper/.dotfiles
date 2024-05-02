{ ... }: {
  programs.nixvim.opts = {
    number = true;
    relativenumber = true;
    colorcolumn = "80";
    # Vertical scroll
    scrolloff = 8;
    # Horizontal scroll
    sidescrolloff = 8;
    # Turn off undofile
    undofile = false;
    # Create folds with visual selection
    foldmethod = "manual";
    # Hide Command line
    cmdheight = 0;
    clipboard = "";
  };
}

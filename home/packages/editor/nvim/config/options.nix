{ ... }: {
  programs.nixvim.opts = {
    # Number line
    number = true;
    relativenumber = true;

    # Scroll
    scrolloff = 8; # Vertical scroll
    sidescrolloff = 8; # Horizontal scroll

    undofile = false; # Turn off undofile

    foldmethod = "manual"; # Create folds with visual selection

    # UI
    cmdheight = 0; # Hide Command line
    signcolumn = "yes";
    colorcolumn = "80";

    clipboard = "";

    # tab settings
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;

    splitbelow = true;

    ignorecase = true;
    smartcase = true;
    smartindent = true;
    termguicolors = true;
  };
}

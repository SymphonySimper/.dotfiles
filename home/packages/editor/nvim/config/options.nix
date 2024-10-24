{ ... }:
{
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
    signcolumn = "yes";
    wrap = false;

    clipboard = "";

    # tab settings
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;

    splitbelow = true;
    splitright = true;

    ignorecase = true;
    smartcase = true;
    smartindent = true;
    termguicolors = true;
  };
}

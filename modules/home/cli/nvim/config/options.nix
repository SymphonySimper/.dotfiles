{ ... }:
{
  programs.nixvim.opts = {
    # line
    ## number
    number = true;
    relativenumber = true;
    ## wrap
    wrap = false;
    linebreak = true;
    breakindent = true;
    ## scroll
    scrolloff = 8; # Vertical scroll
    sidescrolloff = 8; # Horizontal scroll
    ## misc
    smartindent = true;
    foldmethod = "manual"; # Create folds with visual selection

    # column
    signcolumn = "yes";

    # status line & cmd
    ruler = false; # do not show cursor position
    showcmd = false; # do not show key pressed on cmd

    # tab settings
    tabstop = 2;
    shiftwidth = 2;
    shiftround = true;
    expandtab = true;

    # split
    splitbelow = true;
    splitright = true;

    # serach
    ignorecase = true;
    smartcase = true;
    inccommand = "split"; # preview for `%s/foo/bar/g`

    # file
    clipboard = "";
    undofile = false; # Turn off undofile
    confirm = true; # prompt to save changes

    # misc
    swapfile = false; # Turn off swapfile
  };
}

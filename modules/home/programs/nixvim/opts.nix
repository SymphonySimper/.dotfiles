{ ... }: {
  programs.nixvim.opts = {
    number = true;
    relativenumber = true;

    wrap = true;
    linebreak = true;

    scrolloff = 8; # Vertical scroll
    sidescrolloff = 8; # Horizontal scroll

    signcolumn = "yes";
    cursorline = true;

    tabstop = 2;
    shiftwidth = 2;
    shiftround = true;
    expandtab = true;
    smartindent = true;

    splitbelow = true;
    splitright = true;

    ignorecase = true;
    smartcase = true;
    inccommand = "split"; # preview for `%s/foo/bar/g`

    clipboard = "";
    undofile = false; # Turn off undofile
    confirm = true; # prompt to save changes

    swapfile = false; # Turn off swapfile
  };
}

{ ... }: {
  programs.neovim.initLua = ''
    vim.opt.number = true;
    vim.opt.relativenumber = true;

    vim.opt.wrap = true;
    vim.opt.linebreak = true;

    vim.opt.scrolloff = 8; -- Vertical scroll
    vim.opt.sidescrolloff = 8; -- Horizontal scroll

    vim.opt.signcolumn = "yes";
    vim.opt.cursorline = true;

    vim.opt.tabstop = 2;
    vim.opt.shiftwidth = 2;
    vim.opt.shiftround = true;
    vim.opt.expandtab = true;

    vim.opt.splitbelow = true;
    vim.opt.splitright = true;

    vim.opt.ignorecase = true;
    vim.opt.smartcase = true;
    vim.opt.inccommand = "split"; -- preview for `%s/foo/bar/g`

    vim.opt.clipboard = "";
    vim.opt.undofile = false; -- Turn off undofile
    vim.opt.confirm = true; -- prompt to save changes

    vim.opt.swapfile = false; -- Turn off swapfile
  '';
}

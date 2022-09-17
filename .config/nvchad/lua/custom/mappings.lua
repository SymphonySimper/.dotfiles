local M = {}
local e = "<CR>"
local l = "<leader>"

M.general = {
  n = {
    [l .. "f"] = { "<cmd> lua vim.lsp.buf.formatting()" .. e, "Fromatting" },
  },
}

M.nvimtree = {
  n = {
    [l .. "e"] = { "<cmd> NvimTreeToggle" .. e, "Toggle NvimTree" },
  },
}

return M

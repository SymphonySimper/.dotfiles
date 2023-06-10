return {
  "nvim-lualine/lualine.nvim",
  opts = function()
    require("lualine").setup({
      options = {
        component_separators = "|",
        section_separators = { right = "" },
      },
    })
  end,
}

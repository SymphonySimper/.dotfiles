local plugins = {
  -- UI
  "akinsho/bufferline.nvim",
  -- "folke/noice.nvim",
  "goolord/alpha-nvim",
  "nvimdev/dashboard-nvim",
  "rcarriga/nvim-notify",
  "stevearc/dressing.nvim",
  -- Utils
  "folke/flash.nvim",
  "folke/persistence.nvim",
  "dstein64/vim-startuptime",
}

local disabedPlugins = {}
for _, plugin in ipairs(plugins) do
  table.insert(disabedPlugins, { plugin, enabled = false })
end

return disabedPlugins

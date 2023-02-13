local overrides = require "custom.plugins.overrides"

return {

  ["goolord/alpha-nvim"] = { disable = false },
  ["folke/which-key.nvim"] = { disable = false },

  -- Override plugin definition options
  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.lspconfig"
    end,
  },

  -- overrde plugin configs
  ["nvim-treesitter/nvim-treesitter"] = {
    override_options = overrides.treesitter,
  },

  ["williamboman/mason.nvim"] = {
    override_options = overrides.mason,
  },

  ["kyazdani42/nvim-tree.lua"] = {
    override_options = overrides.nvimtree,
  },

  -- Install a plugin
  ["max397574/better-escape.nvim"] = {
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  -- code formatting, linting etc
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "custom.plugins.null-ls"
    end,
  },

  -- autosave
  ["Pocco81/auto-save.nvim"] = {
    event = "VimEnter",
    module = "auto-save",
    config = function()
      require("auto-save").setup {
        enabled = true,
        execution_message = {
          cleaning_interval = 1000,
        },
        trigger_events = { "InsertLeave", "TextChanged" },
        write_all_buffers = true,
        debounce_delay = 135,
        condition = function(buf)
          local fn = vim.fn
          local utils = require "auto-save.utils.data"

          if
            fn.getbufvar(buf, "&modifiable") == 1
            and utils.not_in(fn.getbufvar(buf, "&filetype"), {})
            and utils.not_in(fn.expand "%:t", {
              "packer.lua",
            })
          then
            return true -- met condition(s), can save
          end
          return false -- can't save
        end,
      }
    end,
  },
}

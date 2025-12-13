return {
  {
    'folke/tokyonight.nvim',
    -- lazy = false, -- Load immediately
    -- priority = 1000, -- Load before other plugins
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        transparent = false,
        styles = {
          comments = { italic = true },
        },
      }

      -- vim.cmd.colorscheme 'tokyonight-moon'
    end,
  },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'soft'

      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.gruvbox_material_enable_italic = true
      vim.cmd.colorscheme 'gruvbox-material'
    end,
  },
}

-- vim: ts=2 sts=2 sw=2 et

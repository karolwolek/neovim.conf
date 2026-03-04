return {
  'saxon1964/neovim-tips',
  version = '*', -- Only update on tagged releases
  lazy = false, -- Load on startup for daily tip
  dependencies = {
    'MunifTanjim/nui.nvim',
    -- OPTIONAL: Choose your preferred markdown renderer (or omit for raw markdown)
    'MeanderingProgrammer/render-markdown.nvim', -- Clean rendering
    -- OR: "OXY2DEV/markview.nvim", -- Rich rendering with advanced features
  },
  opts = {
    -- OPTIONAL: Daily tip mode (default: 1)
    daily_tip = 1, -- 0 = off, 1 = once per day, 2 = every startup
    -- OPTIONAL: Bookmark symbol (default: "🌟 ")
    bookmark_symbol = '🌟 ',
  },
  -- init = function()
  --   -- OPTIONAL: Change to your liking or drop completely
  --   -- The plugin does not provide default key mappings, only commands
  --   local map = vim.keymap.set
  --   map('n', '<leader>nto', ':NeovimTips<CR>', { desc = 'Neovim tips', silent = true })
  --   map('n', '<leader>ntb', ':NeovimTipsBookmarks<CR>', { desc = 'Bookmarked tips', silent = true })
  --   map('n', '<leader>nte', ':NeovimTipsEdit<CR>', { desc = 'Edit your Neovim tips', silent = true })
  --   map('n', '<leader>nta', ':NeovimTipsAdd<CR>', { desc = 'Add your Neovim tip', silent = true })
  --   map('n', '<leader>nth', ':help neovim-tips<CR>', { desc = 'Neovim tips help', silent = true })
  --   map('n', '<leader>ntr', ':NeovimTipsRandom<CR>', { desc = 'Show random tip', silent = true })
  --   map('n', '<leader>ntp', ':NeovimTipsPdf<CR>', { desc = 'Open Neovim tips PDF', silent = true })
  -- end,
}

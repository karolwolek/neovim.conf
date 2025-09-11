return {
  'shortcuts/no-neck-pain.nvim',
  version = '*',
  cmd = 'NoNeckPain',
  lazy = true,
  mappings = {},
  config = function()
    -- INFO: I use config for dynamic obsidian todays note injection
    local function get_daily_note()
      local obClient = require('obsidian').get_client()
      return obClient:daily(0, { no_write = false, load = {
        load_contents = false,
      } }).path.filename
    end
    -- global width
    vim.g.nnwidth = 100

    local nnp = require 'no-neck-pain'
    nnp.setup {
      width = vim.g.nnwidth,
      autocmds = {
        skipEnteringNoNeckPainBuffer = true,
      },
      mappings = {
        enabled = false,
      },
      buffers = {
        setNames = false,
        scratchPad = {
          enabled = false,
          pathToFile = get_daily_note(),
        },
        bo = {
          filetype = 'md',
        },
        right = {
          enabled = false,
        },
      },
    }
  end,
}

return {
  'shortcuts/no-neck-pain.nvim',
  version = '*',
  cmd = 'NoNeckPain',
  lazy = true,
  mappings = {},
  config = function()
    local function get_scratch_pad()
      local Path = require 'plenary.path'
      local scratch = ''
      if vim.fn.has_key(vim.fn.environ(), 'SCRATCH') == nil then
        throw "There is no SCRATCH enviromental variable declared, can't process"
      else
        scratch = vim.fn.environ()['SCRATCH']
      end
      local buff_filename = vim.api.nvim_buf_get_name(0):gsub('%.', '_')
      local scratch_path = Path:new(scratch, buff_filename)
      return scratch_path.filename .. '.md'
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
          pathToFile = get_scratch_pad(),
        },
        bo = {
          filetype = 'markdown',
        },
        right = {
          enabled = false,
        },
      },
      NeoTree = {
        -- The position of the tree.
        ---@type "left"|"right"
        position = 'left',
        -- When `true`, if the tree was opened before enabling the plugin, we will reopen it.
        reopen = true,
      },
    }
  end,
}

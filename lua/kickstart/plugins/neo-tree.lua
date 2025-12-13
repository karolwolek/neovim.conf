return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  lazy = false, -- take over netrw as soon as neovim starts
  opts = {
    window = {
      mappings = {
        ['\\'] = 'close_window',
        ['R'] = 'easy',
      },
    },
    commands = {
      ['easy'] = function(state)
        local node = state.tree:get_node()
        local path = node.type == 'directory' and node.path or vim.fs.dirname(node.path)
        require('easy-dotnet').create_new_item(path, function()
          require('neo-tree.sources.manager').refresh(state.name)
        end)
      end,
    },
  },
}

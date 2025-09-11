-- lazy.nvim
return {
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      styles = {
        -- INFO: show top right of screen
        snacks_image = {
          relative = 'editor',
          col = -1,
        },
      },
      image = {
        doc = {
          enabled = true,
          inline = false,
          float = true,
          max_width = 80,
          max_height = 40,
          conceal = function(_, type)
            require('snacks').image.hover()
            return type == 'math'
          end,
        },
      },
      ---@class snacks.dashboard.Config
      dashboard = {
        preset = {
          pick = 'telescope.nvim',
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'N', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = '󰂺 ',
              key = 'n',
              desc = 'Notes',
              action = function()
                vim.fn.chdir(vim.fs.abspath '~/Documents/notes/')
                vim.cmd.edit 'tags.md'
              end,
            },
            { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = '󰒲 ', key = 'L', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
          header = [[
          ██████╗  █████╗   ███╗  ██╗ █████╗ ████████╗    
          ██╔══██╗██╔══██╗  ████╗ ██║██╔══██╗╚══██╔══╝    
          ██║  ██║██║  ██║  ██╔██╗██║██║  ██║   ██║       
          ██║  ██║██║  ██║  ██║╚████║██║  ██║   ██║       
          ██████╔╝╚█████╔╝  ██║ ╚███║╚█████╔╝   ██║       
          ╚═════╝  ╚════╝   ╚═╝  ╚══╝ ╚════╝    ╚═╝       

           ██████╗ ██╗██╗   ██╗███████╗  ██╗   ██╗██████╗ 
          ██╔════╝ ██║██║   ██║██╔════╝  ██║   ██║██╔══██╗
          ██║  ██╗ ██║╚██╗ ██╔╝█████╗    ██║   ██║██████╔╝
          ██║  ╚██╗██║ ╚████╔╝ ██╔══╝    ██║   ██║██╔═══╝ 
          ╚██████╔╝██║  ╚██╔╝  ███████╗  ╚██████╔╝██║     
           ╚═════╝ ╚═╝   ╚═╝   ╚══════╝   ╚═════╝ ╚═╝     
      ]],
        },
        sections = {
          { section = 'header' },
          { section = 'keys', gap = 1, padding = 1 },
          { section = 'startup' },
        },
      },
    },
  },
}

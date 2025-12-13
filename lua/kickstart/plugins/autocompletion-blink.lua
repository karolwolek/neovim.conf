return {
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        -- follow latest release.
        version = 'v2.*',
        build = 'make install_jsregexp',
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
          },
        },
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
          -- friendly-snippets - enable standardized comments snippets
          require('luasnip').filetype_extend('typescript', { 'tsdoc' })
          require('luasnip').filetype_extend('javascript', { 'jsdoc' })
          require('luasnip').filetype_extend('lua', { 'luadoc' })
          require('luasnip').filetype_extend('python', { 'pydoc' })
          require('luasnip').filetype_extend('cs', { 'csharpdoc' })
          require('luasnip').filetype_extend('java', { 'javadoc' })
          require('luasnip').filetype_extend('c', { 'cdoc' })
          require('luasnip').filetype_extend('cpp', { 'cppdoc' })
          require('luasnip').filetype_extend('php', { 'phpdoc' })
          require('luasnip').filetype_extend('kotlin', { 'kdoc' })
          require('luasnip').filetype_extend('ruby', { 'rdoc' })
          require('luasnip').filetype_extend('sh', { 'shelldoc' })
          -- razor with html
          require('luasnip').filetype_extend('razor', { 'html' })
        end,
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'normal',
      },

      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
          window = {
            border = 'rounded',
          },
        },
        menu = {
          border = 'rounded',
          draw = {
            columns = { { 'kind_icon', 'label', 'label_description', gap = 1 }, { 'kind' } },
            components = {},
          },
        },
        list = {
          selection = {
            auto_insert = function(_)
              return vim.bo.filetype ~= 'markdown'
            end,
          },
          cycle = {
            from_bottom = true,
            from_top = true,
          },
        },
      },

      sources = {
        default = { 'snippets', 'lsp', 'path', 'lazydev', 'easy-dotnet', 'buffer', 'omni' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          ['easy-dotnet'] = {
            name = 'easy-dotnet',
            enabled = true,
            module = 'easy-dotnet.completion.blink',
            score_offset = 10000,
            async = true,
          },
        },
      },

      snippets = { preset = 'luasnip' },

      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true, window = { border = 'rounded' } },
    },
  },
}

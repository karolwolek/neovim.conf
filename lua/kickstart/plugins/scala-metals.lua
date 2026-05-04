return {
  'scalameta/nvim-metals',
  ft = { 'scala', 'sbt', 'java' },
  opts = function()
    local metals_config = require('metals').bare_config()

    -- settings
    metals_config.settings = {
      inlayHints = {
        implicitArguments = { enable = true },
        implicitConversions = { enable = true },
        inferredTypes = { enable = true },
      },
    }

    -- -- "on" will enable the custom Metals status extension and you *have* to have
    -- -- a have settings to capture this in your statusline or else you'll not see
    -- -- any messages from metals. There is more info in the help docs about this
    metals_config.init_options.statusBarProvider = 'on'

    metals_config.on_attach = function(client, bufnr)
      -- your on_attach function
    end

    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup('nvim-metals', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
      pattern = self.ft,
      callback = function()
        require('metals').initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}

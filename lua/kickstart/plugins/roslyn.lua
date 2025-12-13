return {
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'razor' },
    init = function()
      -- We add the Razor file types before the plugin loads.
      vim.filetype.add {
        extension = {
          razor = 'razor',
          cshtml = 'razor',
        },
      }
    end,
  },
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
    ft = { 'cs', 'razor' },
    config = function()
      local dotnet = require 'easy-dotnet'
      -- Options are not required
      dotnet.setup {
        lsp = {
          enabled = false, -- Enable builtin roslyn lsp
          roslynator_enabled = true, -- Automatically enable roslynator analyzer
          analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
          config = {},
        },
      }
    end,
  },
}

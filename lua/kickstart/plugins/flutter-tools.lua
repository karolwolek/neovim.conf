return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  -- flutter-tools requires a .setup({}) call to actually function.
  -- config = true automatically calls require('flutter-tools').setup({})
  config = true,
}

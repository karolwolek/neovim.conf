return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    main = 'ibl',
    opts = {
      scope = {
        exclude = {
          language = {
            'markdown',
          },
        },
      },
    },
  },
}

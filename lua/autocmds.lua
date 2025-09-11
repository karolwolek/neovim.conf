-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- close help with `q` key
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('q-close-help', { clear = true }),
  pattern = { 'help', 'man' },
  desc = 'Use q to close the window',
  command = 'nnoremap <buffer> q <cmd>quit<cr>',
})

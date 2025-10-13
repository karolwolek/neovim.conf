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

-- markdown scrolloff

local md_scrolloff_group = vim.api.nvim_create_augroup('markdown-autoscroll', { clear = true })
local options_scrolloff = vim.opt.scrolloff -- ensure options gets loaded first

vim.api.nvim_create_autocmd('BufEnter', {
  group = md_scrolloff_group,
  pattern = { '*.md' },
  desc = 'Change autoscroll to always be in the middle while opening markdown file',
  callback = function()
    vim.opt.scrolloff = 25 -- big number to center
  end,
})
vim.api.nvim_create_autocmd('BufLeave', {
  group = md_scrolloff_group,
  pattern = { '*.md' },
  desc = 'Bring back the regular scrolloff',
  callback = function()
    vim.opt.scrolloff = options_scrolloff
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('markdown.fold', {}),
  pattern = 'markdown',
  callback = function()
    local o = vim.o
    local opt = vim.opt
    o.foldmethod = 'expr' -- Define folds using an expression
    o.foldlevel = 99 -- Open all folds by default upon opening a file
    opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Use Treesitter for folding
    opt.foldtext = '' -- Syntax highlight first line of fold
  end,
})

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>:echo<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Move windows focus
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move the lines up and down
vim.keymap.set({ 'n', 'i' }, '<C-n>', '<ESC>ddp', { noremap = true, desc = 'Move the line down one line' })
vim.keymap.set({ 'n', 'i' }, '<C-p>', '<ESC>ddkP', { noremap = true, desc = 'Move the line up one line' })

-- lowercase/uppercase the word
vim.keymap.set('n', '<S-u>', 'vawU', { noremap = true, desc = 'Convert a word to the uppercase' })
vim.keymap.set('n', '<S-l>', 'vawu', { noremap = true, desc = 'convert a word to the lowercase' })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, desc = 'Move half page down and center cursor' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, desc = 'Move half page up and center cursor' })

-- my custom terminal conf
vim.keymap.set('n', '<leader>tt', '<cmd>OpenTerminal<cr>', { desc = '[T]oggle [T]erminal' })

-- INFO: no-neck-pain centering windows keymaps
-- ============================================================================
vim.keymap.set('n', '<leader>cc', function()
  local nnp_state = require 'no-neck-pain.state'
  local nnp_main = require 'no-neck-pain.main'

  nnp_main.enable ''
  if not nnp_state:is_side_enabled_and_valid 'left' then
    nnp_main.toggle_side('', 'left')
  end
  if not nnp_state:is_side_enabled_and_valid 'right' then
    nnp_main.toggle_side('', 'right')
  end
end, { desc = '[C]enter in the [C]enter', silent = true, noremap = true })
-- ============================================
vim.keymap.set('n', '<leader>cr', function()
  local nnp_state = require 'no-neck-pain.state'
  local nnp_main = require 'no-neck-pain.main'

  nnp_main.enable ''
  if not nnp_state:is_side_enabled_and_valid 'left' then
    nnp_main.toggle_side('', 'left')
  end
  if nnp_state:is_side_enabled_and_valid 'right' then
    nnp_main.toggle_side('', 'right')
  end
end, { desc = '[C]enter to the [R]ight', silent = true, noremap = true })
-- ============================================
vim.keymap.set('n', '<leader>cl', function()
  local nnp_state = require 'no-neck-pain.state'
  local nnp_main = require 'no-neck-pain.main'

  nnp_main.enable ''
  if not nnp_state:is_side_enabled_and_valid 'right' then
    nnp_main.toggle_side('', 'right')
  end
  if nnp_state:is_side_enabled_and_valid 'left' then
    nnp_main.toggle_side('', 'left')
  end
end, { desc = '[C]enter to the [L]eft', silent = true, noremap = true })
-- ============================================
vim.keymap.set('n', '<leader>c,', function()
  local nnp = require 'no-neck-pain'
  local nnp_state = require 'no-neck-pain.state'

  if nnp_state:has_tabs() and nnp_state:is_active_tab_registered() then
    print 'resizing'
    nnp.resize(vim.g.nnwidth)
  end
end, { desc = '[C]enter restore default size', silent = true, noremap = true })
-- ============================================
vim.keymap.set('n', '<leader><leader>', '<cmd>NoNeckPain<CR>', { desc = '[C]enter toggle state', silent = true, noremap = true })
-- ============================================
vim.keymap.set({ 'n', 'i', 'v', 't' }, '<M-->', function()
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, 'NoNeckPainWidthDown') -- No warning
end, { desc = 'Decrease window size', silent = true, noremap = true })
-- ============================================
vim.keymap.set({ 'n', 'i', 'v', 't' }, '<M-=>', function()
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, 'NoNeckPainWidthUp')
end, { desc = 'Increase window size', silent = true, noremap = true })
-- ============================================

-- NOTE: TELESCOPE
-- ============================================================================

vim.keymap.set('n', '<leader>sh', '<cmd>Telescope help_tags<cr>', { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', '<cmd>Telescope keymaps<cr>', { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', '<cmd>Telescope find_files<cr>', { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>ss', '<cmd>Telescope builtin<cr>', { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sw', '<cmd>Telescope grep_string<cr>', { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', '<cmd>Telescope live_grep<cr>', { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', '<cmd>Telescope diagnostics<cr>', { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', '<cmd>Telescope resume<cr>', { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', '<cmd>Telescope oldfiles<cr>', { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>sb', '<cmd>Telescope buffers<cr>', { desc = '[S]earch existing [B]uffers' })

vim.keymap.set('n', '<leader>/', function()
  local builtin = require 'telescope.builtin'
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sc', function()
  local builtin = require 'telescope.builtin'
  builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [C]onfig files' })

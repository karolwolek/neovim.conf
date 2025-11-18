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
vim.keymap.set('n', '<leader>ts', function()
  ---@diagnostic disable-next-line: param-type-mismatch
  pcall(vim.cmd, 'NoNeckPainScratchPad')
end, { desc = '[T]oggle [S]hratchpad', silent = true, noremap = true })

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

-- NOTE: OBSIDIAN
-- ============================================================================

local obsidian_group = vim.api.nvim_create_augroup('obsidian-base', { clear = true })

vim.api.nvim_create_autocmd('User', {
  group = obsidian_group,
  pattern = 'ObsidianNoteEnter',
  callback = function(event)
    -- Toggle check-boxes.
    vim.keymap.set('n', '<leader>ch', '<cmd>Obsidian toggle_checkbox<cr>', {
      buffer = event.buf,
      desc = 'Toggle check-box',
    })
    -- Smart action depending on context, either follow link or toggle checkbox.
    vim.keymap.set('n', '<cr>', function()
      return require('obsidian').util.smart_action()
    end, {
      buffer = event.buf,
      desc = 'Obsidian smart action',
    })
    -- paste image
    vim.keymap.set({ 'n', 'i', 'v' }, '<M-p>', function()
      return require('kickstart.obutils').paste_image_custom()
    end, {
      buffer = event.buf,
      desc = '[P]aste image',
    })
    -- open links for this note
    vim.keymap.set('n', '<leader>nl', '<cmd>Obsidian links<cr>', { buffer = event.buf, desc = '[N]ote [L]inks' })
    -- open backlinks for this note
    vim.keymap.set('n', '<leader>nb', '<cmd>Obsidian backlinks<cr>', { buffer = event.buf, desc = '[N]ote [B]acklinks' })
  end,
})

vim.api.nvim_create_autocmd('User', {
  group = obsidian_group,
  pattern = { 'ObsidianNoteEnter', '*/dailies/*.md' },
  callback = function(event)
    vim.keymap.set('n', '<Right>', function()
      return require('kickstart.obutils').next_daily()
    end, { buffer = event.buf, desc = 'Previous daily' })
    vim.keymap.set('n', '<Left>', function()
      return require('kickstart.obutils').prev_daily()
    end, { buffer = event.buf, desc = 'Next daily' })
  end,
})

vim.api.nvim_create_autocmd('User', {
  group = obsidian_group,
  pattern = { 'ObsidianNoteEnter', '*/inbox/*.md' },
  callback = function(event)
    -- accept the note from the inbox
    vim.keymap.set('n', '<leader>na', function()
      return require('kickstart.obutils').accept_inbox_note()
    end, { buffer = event.buf, desc = '[N]ote [A]cceept' })
  end,
})

-- search for tags in current vault
vim.keymap.set('n', '<leader>st', '<cmd>Obsidian tags<cr>', { desc = '[S]earch [T]ags' })
-- search for notes in current vault
vim.keymap.set('n', '<leader>sn', '<cmd>Obsidian quick_switch<cr>', { desc = '[S]earch [N]otes' })
-- open dailies with picker
vim.keymap.set('n', '<leader>nd', '<cmd>Obsidian dailies<cr>', { desc = '[N]ote [D]ailies' })
-- open yesterdays note
vim.keymap.set('n', '<leader>ny', '<cmd>Obsidian yesterday<cr>', { desc = '[N]ote [Y]esterday' })
-- open todays note
vim.keymap.set('n', '<leader>nt', '<cmd>Obsidian today<cr>', { desc = '[N]ote [T]oday' })
-- search for notes in the inbox
vim.keymap.set('n', '<leader>si', function()
  return require('kickstart.obutils').search_inbox()
end, { desc = '[S]earch [I]nbox notes' })
-- open a new note
vim.keymap.set('n', '<leader>nn', function()
  return require('kickstart.obutils').open_new_note()
end, { desc = '[N]ote [N]ew' })

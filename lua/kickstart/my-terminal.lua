local term_buf = nil

local open_terminal = function()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    local winid = vim.fn.bufwinid(term_buf)

    if winid ~= -1 and vim.api.nvim_win_is_valid(winid) then
      local winnum = vim.fn.bufwinnr(term_buf)
      vim.cmd(string.format('%dwincmd w', winnum))
    else
      -- buffer hidden reopen in bottom split
      -- botright opens bottom split, sbuffer open buffer in split
      vim.cmd('botright sbuffer' .. term_buf)
    end
  else
    -- create a new terminal
    vim.cmd [[
      botright new
      term
    ]]
    term_buf = vim.api.nvim_get_current_buf()
  end

  vim.api.nvim_win_set_height(0, 15)
end

vim.api.nvim_create_user_command('OpenTerminal', open_terminal, {})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.cmd 'startinsert'
  end,
  desc = 'Disable numbers in terminal and start insert',
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = 'custom-term-open',
  desc = 'Close terminal with q',
  command = 'map <buffer> q <cmd>quit<cr>',
})

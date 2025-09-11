local M = {}

M.search_inbox = function()
  -- function redefinition for recursion
  -- after deleting the function is called again for refresh
  local function search_inbox()
    local client = require('obsidian').get_client()
    local picker = assert(client:picker())
    picker:find_files {
      prompt_title = 'Notes in the inbox',
      dir = vim.fn.environ()['VAULT'] .. 'inbox',
      -- TODO: refactor for multiple selection
      selection_mappings = {
        ['<C-d>'] = {
          callback = function(note_or_path)
            ---@type obsidian.Note
            local note = require 'obsidian.note'
            if note.is_note_obj(note_or_path) then
              note = note
            else
              note = note.from_file(note_or_path)
            end

            local config_trash = client.opts.trash_dir -- config injected (trash_dir)
            local target_dir = client.current_workspace.path:joinpath(config_trash)
            if not target_dir then
              target_dir = client.current_workspace.path:joinpath '.trash'
            end
            if not target_dir:is_dir() then
              target_dir:mkdir()
            end

            local target_path = target_dir:joinpath(note.path.name)

            local success, err = pcall(function()
              os.rename(note.path.filename, target_path.filename)
            end)

            if success then
              print('Note moved to: ' .. target_path.filename)
              search_inbox()
            else
              print('Error moving note: ' .. (err or 'Unknown error'))
            end
          end,
          desc = 'Discard note',
          keep_open = true,
          allow_multiple = false,
        },
      },
    }
  end
  search_inbox()
end

---This function checks only if the formats of two dates is equal
---@param date string date to check on
---@param format string format to compare on
---@return boolean
local function check_date_format(date, format)
  -- create a test date to compare format on
  local test_date = tostring(os.date(format))

  -- replace all alpabetic symbols with "w"
  test_date = vim.fn.substitute(test_date, '\\w', 'w', 'g')
  date = vim.fn.substitute(date, '\\w', 'w', 'g')

  -- replace all numeric symbols with "0"
  test_date = vim.fn.substitute(test_date, '\\d', '0', 'g')
  date = vim.fn.substitute(date, '\\d', '0', 'g')

  return date == test_date
end

local function file_exists(name)
  local f = io.open(name, 'r')
  return f ~= nil and io.close(f)
end

M.navigate_daily = function(prev)
  -- unix posix utils for c
  local time = require 'posix.time'

  local client = require('obsidian').get_client()
  prev = prev or false

  local note = client:current_note()

  if note == nil then
    print "You don't have a note opened"
    return
  end

  local dailies_title_format = client.opts.daily_notes.date_format
  if not dailies_title_format then
    dailies_title_format = client._default_opts.daily_notes.date_format
  end
  local id = note.path.stem

  -- compare date formats, dailies are titled by the date format from config
  ---@diagnostic disable-next-line
  if not check_date_format(id, dailies_title_format) then
    print 'You are outside daily notes'
    return
  end

  -- this is bottom line for searching last note, beginning of my system
  local bottom_limit_timestamp = os.time { year = 2025, month = 5, day = 25 }

  -- this is upper line for searching
  local today = os.date '*t'
  local upper_limit_timestamp = os.time {
    year = today.year,
    month = today.month,
    day = today.day,
    hour = 23,
    min = 59,
  }

  -- parse datetime string to unix timestamp based on format
  local PosixTm = time.strptime(id, dailies_title_format)
  local note_timestamp = time.mktime(PosixTm)
  local path = ''

  while not file_exists(path) and note_timestamp > bottom_limit_timestamp and note_timestamp < upper_limit_timestamp do
    -- add/remove one day
    if not prev then
      note_timestamp = note_timestamp + (24 * 60 * 60)
    else
      note_timestamp = note_timestamp - (24 * 60 * 60)
    end

    path = client:daily_note_path(note_timestamp).filename
  end

  if note_timestamp < bottom_limit_timestamp or note_timestamp > upper_limit_timestamp then
    return
  end

  client:open_note(path)
end

M.prev_daily = function()
  return M.navigate_daily(true)
end

M.next_daily = function()
  return M.navigate_daily()
end

M.open_new_note = function()
  -- TODO: extract pop up logic
  local width = 40
  local height = 1

  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  -- disable blink completion in this pop up window due to some errors
  vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('new-note-obsidian', { clear = true }),
    buffer = buf,
    callback = function()
      vim.b.completion = false
    end,
  })

  local win_config = {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded',
    title = ' Enter the note title ',
    title_pos = 'center',
  }

  local win = vim.api.nvim_open_win(buf, true, win_config)

  vim.cmd 'startinsert'

  -- accept the title for the note with <enter>
  vim.keymap.set('i', '<CR>', function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local title = lines[1] or ''
    if title == '' then
      print 'Please enter a note title'
      return
    end

    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })

    vim.cmd { cmd = 'ObsidianNew', args = { title } }
    vim.cmd 'stopinsert'
  end, { buffer = buf, noremap = true, silent = true })

  -- with <ESC> close the floating window
  vim.keymap.set('i', '<ESC>', function()
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    vim.cmd 'stopinsert'
  end, { buffer = buf, noremap = true, silent = false })
end

M.accept_inbox_note = function()
  local client = require('obsidian').get_client()
  local bufer = vim.api.nvim_get_current_buf()
  local note = client:current_note(bufer)

  if not note then
    print 'There are currently no notes open'
    return
  end

  local notes_subdir = client.opts.notes_subdir
  local expected_path = client.current_workspace.path:joinpath(notes_subdir):joinpath(note.path.name)

  if note.path ~= expected_path then
    print 'Not in the inbox'
    return
  end

  if not note.tags or #note.tags == 0 then
    print 'No tags found'
    return
  end

  local target_tag = note.tags[1]
  local target_name = note.path.name:gsub('inbox', '')
  local target_path = client.current_workspace.path:joinpath 'notes'

  if target_tag:find '^projects' then
    target_path = target_path:joinpath('projects', target_name)
  elseif target_tag:find '^areas' then
    target_path = target_path:joinpath('areas', target_name)
  elseif target_tag:find '^resources' then
    target_path = target_path:joinpath('resources', target_name)
  elseif target_tag:match '^archives' then
    print 'Cannot accept into archive'
    return
  else
    print 'Please attach a base tag out of "projects", "areas", "resources" as a first tag'
    return
  end

  -- Ensure the target directory exists
  local target_dir = target_path:parent()
  if not target_dir then
    print 'Error with resolving target directory'
    return
  end

  if not vim.fn.isdirectory(target_dir.filename) then
    vim.fn.mkdir(target_dir.filename, 'p')
  end

  -- try to move the file
  local success, err = pcall(function()
    os.rename(note.path.filename, target_path.filename)
  end)

  if success then
    vim.api.nvim_buf_delete(bufer, { force = true })
    print('Note moved to: ' .. target_path.filename)
    client:open_note(target_path.filename)
  else
    print('Error moving note: ' .. (err or 'Unknown error'))
  end
end

-- paste image with name prompt
-- TODO: try to use popup under the cursor
M.paste_image_custom = function()
  local client = require('obsidian').get_client()
  client.opts.attachments.img_name_func = nil
  local success, err = pcall(vim.cmd, 'Obsidian paste_img')
  if not success then
    print 'There is not image in the clipboard'
  end
end

return M

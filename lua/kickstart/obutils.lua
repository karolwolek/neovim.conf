local M = {}
local Api = require 'obsidian.api'
local Path = require 'obsidian.path'
local Note = require 'obsidian.note'
local Img = require 'obsidian.img_paste'
local Log = require 'obsidian.log'

M.search_inbox = function()
  -- function redefinition for recursion
  -- after deleting the function is called again for refresh
  local picker = assert(Obsidian.picker)

  ---@param note_fpath string full file path to note
  local function move_note_to_trash(note_fpath)
    local workspace_path = Obsidian.workspace.path.filename
    local trash_dir = Obsidian._opts.trash_dir or '.trash'
    local target_dir = vim.fs.joinpath(workspace_path, trash_dir)

    if vim.fn.isdirectory(target_dir) == 0 then
      vim.fn.mkdir(target_dir)
    end

    local filename = Path.new(note_fpath):is_absolute() and vim.fs.basename(note_fpath) or note_fpath
    local target_path = vim.fs.joinpath(target_dir, filename)

    local ok, err = pcall(function()
      os.rename(note_fpath, target_path)
    end)

    if ok then
      print('Note moved to: ' .. target_path)
      M.search_inbox() -- refresh picker
    else
      print('Error moving note: ' .. (err or 'Unknown error'))
    end
  end

  picker.find_files {
    prompt_title = 'Notes in the inbox',
    dir = vim.fn.environ()['VAULT'] .. 'inbox',
    selection_mappings = {
      ['<C-d>'] = {
        desc = 'Discard note',
        keep_open = true,
        allow_multiple = false,
        callback = function(entry)
          local note_fpath = assert(type(entry) == 'string' and entry or entry.filename)
          if not Api.path_is_note(note_fpath) then
            print('Path is not in the workspace: ' .. note_fpath)
            return
          end
          move_note_to_trash(note_fpath)
        end,
      },
    },
  }
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

  prev = prev or false

  local note = Api.current_note()

  if note == nil then
    print "You don't have a note opened"
    return
  end

  local dailies_title_format = Obsidian.opts.daily_notes.date_format
  if not dailies_title_format then
    dailies_title_format = require('obsidian.config.default').daily_notes.date_format
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

    path = require('obsidian.daily').daily_note_path(note_timestamp).filename
  end

  if note_timestamp < bottom_limit_timestamp or note_timestamp > upper_limit_timestamp then
    return
  end

  Api.open_note(path)
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

    vim.cmd { cmd = 'Obsidian', args = { 'new', title } }
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
  local note = Api.current_note()

  if not note then
    print 'There are currently no notes open'
    return
  end

  local notes_subdir = Obsidian.opts.notes_subdir
  local expected_path = Path.new(vim.fs.joinpath(Obsidian.workspace.path.filename, notes_subdir, note.path.name))

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
  -- local target_path = client.current_workspace.path:joinpath 'notes'
  local target_file_path = vim.fs.joinpath(Obsidian.workspace.path.filename, 'notes')

  if target_tag:find '^projects' then
    target_file_path = vim.fs.joinpath(target_file_path, 'projects', target_name)
  elseif target_tag:find '^areas' then
    target_file_path = vim.fs.joinpath(target_file_path, 'areas', target_name)
  elseif target_tag:find '^resources' then
    target_file_path = vim.fs.joinpath(target_file_path, 'resources', target_name)
  elseif target_tag:match '^archives' then
    print 'Cannot accept into archive'
    return
  else
    print 'Please attach a base tag out of "projects", "areas", "resources" as a first tag'
    return
  end

  -- Ensure the target directory exists
  local target_dir = Path.new(target_file_path):parent()
  if not target_dir then
    print 'Error with resolving target directory'
    return
  end

  if not target_dir:is_dir() then
    target_dir:mkdir { parents = true }
  end

  -- try to move the file
  local success, err = pcall(function()
    os.rename(note.path.filename, target_file_path)
  end)

  if success then
    vim.api.nvim_buf_delete(0, { force = true })
    print('Note moved to: ' .. target_file_path)
    Api.open_note(target_file_path)
  else
    Log.err('Error moving note: ' .. (err or 'Unknown error'))
  end
end

-- TODO: Popraw działanie visual selection
--
-- paste image with name prompt
M.paste_image_custom = function()
  if not Img.clipboard_is_img() then
    return Log.err 'There is no image data in the clipboard'
  end

  local command = 'Obsidian paste_img'
  local selection = Api.get_visual_selection { strict = true }
  if selection then
    vim.cmd 'normal! gv'
    vim.cmd 'normal! d'
    command = command .. ' ' .. selection.selection
  end

  ---@diagnostic disable-next-line
  local success, result = pcall(vim.cmd, command)
  if not success then
    Log.err('there was an Error pasting the image on my side \n', result)
    if selection then
      vim.cmd('normal! i' .. vim.trim(selection.selection))
    end
  end
end

return M

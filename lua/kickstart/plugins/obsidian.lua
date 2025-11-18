local vault = ''
if vim.fn.has_key(vim.fn.environ(), 'VAULT') == nil then
  -- vim.notify("There is no VAULT enviromental variable declared, can't process", vim.log.levels.ERROR)
  throw "There is no VAULT enviromental variable declared, can't process"
else
  vault = vim.fn.environ()['VAULT']
end

return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    event = {
      'BufEnter ' .. vault .. '*.md',
      'BufNewFile ' .. vault .. '*.md',
    },
    cmd = 'Obsidian',
    opts = {
      workspaces = {
        {
          name = 'notes',
          path = vault,
        },
      },
      log_level = vim.log.levels.INFO,
      notes_subdir = 'inbox/',
      new_notes_location = 'notes_subdir',
      trash_dir = '.trash',
      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 2,
        match_case = false,
        create_new = false,
      },
      -- [[ configure daily notes with default template ]]
      daily_notes = {
        folder = 'notes/dailies',
        date_format = '%Y-%m-%d',
        alias_format = '%-d %B, %Y',
        default_tags = { 'pim', 'daily-notes' },
        template = 'daily.md',
        workdays_only = true,
      },

      -- [[ templates location and placeholders]]
      --
      -- I can add some custom placeholders
      templates = {
        folder = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
      },

      checkbox = {
        enabled = true,
        create_new = false,
        order = { ' ', 'x', '!', '>', '~' },
      },

      -- [[ note naming function]]
      --
      -- It attaches the timestamp to each note with pattern 2004-06-16.
      -- If note name is not specified the title is random ( I do not use it since
      -- my custom functions require the title).
      note_id_func = function(title)
        local suffix = ''
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(' ', '_'):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.date '%Y-%m-%d') .. '_' .. suffix
      end,

      preferred_link_style = 'wiki',

      -- [[ open links in firefox ]]
      follow_url_func = function(url)
        vim.ui.open(url, { cmd = { 'firefox' } })
      end,

      -- [[ open images as a regular buffer ]]
      follow_img_func = function(img)
        vim.cmd { cmd = 'edit', args = { img } }
      end,

      --
      -- [[ attachments ]]
      --
      -- Set default images folder,
      -- disable pasting confirmation and set custom filename function
      -- that properly renames the file to attach timestamps and prepares
      -- a string with just the name to inject in the text with a pattern:
      -- [this is example](images/this-is-example-20250616145425.jpg)
      attachments = {
        img_folder = 'images',
        confirm_img_paste = false,
        img_text_func = function(path)
          local name = path.stem
          local parent = path:parent().filename
          local filename = vim.fs.joinpath(parent, name .. os.date '-%Y%m%d%H%M%S' .. path.suffix)
          local target_path = string.gsub(filename, ' ', '-')
          local success, err = pcall(function()
            os.rename(path.filename, target_path)
          end)
          if not success then
            print(err)
          end
          local normalized_path = vim.fs.relpath(Obsidian.dir.filename, target_path)
          return string.format('![%s](%s)', name, normalized_path)
        end,
        img_name_func = function()
          return nil -- force me to create a name
        end,
      },

      footer = {
        enabled = true,
        format = '{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars',
      },

      -- [[ callbacks]]
      --
      -- Various actions for scripting during obsidian lifecycle.
      --
      -- Currently after entering the buffer i set custom `resolve` function for images
      -- in snacks because of the relative to the vault link setup.
      -- After leaving the note i schedule the job to nullify the `resolve`.
      -- Scheduling allows me to avoid the situation while snacks is still trying to render
      -- while i am interfering with config.
      --
      -- Second autocmds is for tag highlight. render-markdown is not detecting these properly
      -- and i need to have obisidan ui off due to incompatibility issues.
      --

      ---@class obsidian.config.CallbackConfig
      ---
      ---Runs right after setup
      ---@field post_setup? fun()
      ---
      ---Runs when entering a note buffer.
      ---@field enter_note? fun(note: obsidian.Note)
      ---
      ---Runs when leaving a note buffer.
      ---@field leave_note? fun(note: obsidian.Note)
      ---
      ---Runs right before writing a note buffer.
      ---@field pre_write_note? fun(note: obsidian.Note)
      ---
      ---Runs anytime the workspace is set/changed.
      ---@field post_set_workspace? fun(workspace: obsidian.Workspace)
      callbacks = {
        enter_note = function(_)
          -- image snacks
          require('snacks.image').config.resolve = function(_, src)
            local workspace_path = Obsidian.workspace.path
            return vim.fs.joinpath(workspace_path.filename, src)
          end
          -- Tag highlighting
          vim.cmd 'highlight myTag guifg=#71d4eb'
          vim.cmd 'match myTag /#[0-9]*[a-zA-Z_\\-\\/][a-zA-Z_\\-\\/0-9]*/'
        end,
        leave_note = function(_)
          -- image snacks
          vim.schedule(function()
            require('snacks.image').config.resolve = nil
          end)
          -- Tag highlighting
          vim.cmd 'highlight clear myTag'
        end,
      },

      --
      -- [[ UI ]]
      --
      -- Disable the obsidian UI because of the incompatibility
      -- with render-markdown plugin
      ui = {
        enable = false,
      },
    },
  },
}

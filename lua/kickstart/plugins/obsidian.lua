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
        confirm_img_paste = true,
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
        -- image_text_func = function(path)
        --   local name = vim.fs.basename(tostring(path))
        --   local encoded_name = require('obsidian.util').urlencode(name)
        --   return string.format('![%s](%s)', name, encoded_name)
        -- end,
        img_name_func = function()
          return '' -- force me to create a name
        end,
      },

      footer = {
        enabled = true,
        format = '{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars',
      },
      --
      --   -- [[ mappings ]]
      --   --
      --   -- Some mappings get attached to a certain buffer,
      --   -- some mappings are using my custom obutils for several note taking system parts.
      --   --
      --   -- The reason they are defined here is that obsidian
      --   -- is managing autocmds with buffer attached mappings itself
      --   -- so i don't need to deal with checking whether the buffer
      --   -- is a part of the workspace or not
      --   mappings = {
      --     -- Toggle check-boxes.
      --     ['<leader>ch'] = {
      --       action = function()
      --         return require('obsidian').util.toggle_checkbox()
      --       end,
      --       opts = { buffer = true, desc = 'Toggle check-box' },
      --     },
      --     -- Smart action depending on context, either follow link or toggle checkbox.
      --     ['<cr>'] = {
      --       action = function()
      --         return require('obsidian').util.smart_action()
      --       end,
      --       opts = { buffer = true, expr = true, desc = 'Obsidian smart action' },
      --     },
      --     -- search for tags in current vault
      --     ['<leader>st'] = {
      --       action = function()
      --         return '<cmd>Obsidian tags<CR>'
      --       end,
      --       opts = { buffer = false, expr = true, noremap = true, desc = '[S]earch [T]ags' },
      --     },
      --     -- search for notes in current vault
      --     ['<leader>sn'] = {
      --       action = function()
      --         return '<cmd>Obsidian quick_switch<CR>'
      --       end,
      --       opts = { buffer = false, expr = true, noremap = true, desc = '[S]earch [N]otes' },
      --     },
      --     -- search for notes in the inbox
      --     ['<leader>si'] = {
      --       action = require('kickstart.obutils').search_inbox,
      --       opts = { buffer = false, expr = false, noremap = true, desc = '[S]earch [I]nbox notes' },
      --     },
      --     -- open a new note
      --     ['<leader>nn'] = {
      --       action = require('kickstart.obutils').open_new_note,
      --       opts = { buffer = false, expr = false, noremap = true, desc = '[N]ote [N]ew' },
      --     },
      --     ['<Right>'] = {
      --       action = require('kickstart.obutils').next_daily,
      --       opts = { buffer = false, expr = false, noremap = true, desc = 'Next daily' },
      --     },
      --     ['<Left>'] = {
      --       action = require('kickstart.obutils').prev_daily,
      --       opts = { buffer = false, expr = false, noremap = true, desc = 'Previous daily' },
      --     },
      --     -- open links for this note
      --     ['<leader>nl'] = {
      --       action = function()
      --         return '<cmd>Obsidian links<cr>'
      --       end,
      --       opts = { buffer = true, expr = true, noremap = true, desc = '[N]ote [L]inks' },
      --     },
      --     -- open backlinks for this note
      --     ['<leader>nb'] = {
      --       action = function()
      --         return '<cmd>Obsidian backlinks<cr>'
      --       end,
      --       opts = { buffer = true, expr = true, noremap = true, desc = '[N]ote [B]acklinks' },
      --     },
      --     -- accept the note from the inbox
      --     ['<leader>na'] = {
      --       action = require('kickstart.obutils').accept_inbox_note,
      --       opts = { buffer = true, expr = false, noremap = true, desc = '[N]ote [A]ccept' },
      --     },
      --     -- paste image
      --     ['<M-p>'] = {
      --       action = require('kickstart.obutils').paste_image_custom,
      --       opts = { buffer = true, expr = false, noremap = true, desc = '[P]aste image without default' },
      --     },
      --     -- open dailies with picker
      --     ['<leader>nd'] = {
      --       action = function()
      --         return '<cmd>Obsidian dailies<cr>'
      --       end,
      --       opts = { buffer = false, expr = true, noremap = true, desc = '[N]ote [D]ailes' },
      --     },
      --     -- open yesterdays note
      --     ['<leader>ny'] = {
      --       action = function()
      --         return '<cmd>Obsidian yesterday<cr>'
      --       end,
      --       opts = { buffer = false, expr = true, noremap = true, desc = '[N]ote [Y]esterday' },
      --     },
      --     -- open todays note
      --     ['<leader>nt'] = {
      --       action = function()
      --         return '<cmd>Obsidian today<cr>'
      --       end,
      --       opts = { buffer = false, expr = true, noremap = true, desc = '[N]ote [T]oday' },
      --     },
      --   },
      --

      --
      --
      --
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

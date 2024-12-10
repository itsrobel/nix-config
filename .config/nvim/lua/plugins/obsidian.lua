function GetWorkspaces()
  local workspaces = {}
  for dir in io.popen([[ls -p $HOME/vaults ]]):lines() do
    local sdir = dir:sub(1, -2)
    local entry = {}
    entry["name"] = sdir
    entry["path"] = string.format("%s/vaults/%s", os.getenv("HOME"), sdir)
    table.insert(workspaces, entry)
  end
  return workspaces
end

function AddKeymaps()
  local wk = require("which-key")
  wk.register({
    ["<leader>o"] = {
      name = "[O]bsidian",
      _ = "which_key_ignore",
      n = { "<cmd>ObsidianNew<CR>", "Obsidian New File" },
      l = {
        name = "Obsidian Link",
        i = { "<cmd>ObsidianLink<CR>", "Link", mode = { "v" } },
        n = { "<cmd>ObsidianLinkNew<CR>", "Link New", mode = { "v" } },
      },
      e = { "<cmd>ObsidianExtractNote<CR>", "Extract Note", mode = { "v" } },
      t = { "<cmd>ObsidianTemplate<CR>", "Obsidian Template" },
      j = {
        name = "[J]ournal",
        t = {
          "<cmd>ObsidianToday<CR>",
          "Obsidian Today",
        },
        l = { "<cmd>ObsidianDailies<CR>", "Obsidian Journal List" },
      },
    },
  })
end

function IsEnabled()
  local workspaces = GetWorkspaces()
  for _, value in ipairs(workspaces) do
    if vim.fn.getcwd():match(value["path"]) then
      AddKeymaps()
      return true
    end
  end
  return false
end

return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  cond = IsEnabled(),
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "folke/which-key.nvim",
    -- see below for full list of optional dependencies 👇
  },
  --TODO: create a function that returns the folders in a directory
  opts = {
    workspaces = GetWorkspaces(),
    -- see below for full list of options 👇
    daily_notes = {
      folder = "journal",
      date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = "%B %-d, %Y",
      -- Optional, default tags to add to each new daily note created.
      default_tags = { "journal" },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = "journal.md", --TODO: I ned to create templates later
    },

    -- templates = {
    --     folder = 'templates',
    --     date_format = '%Y-%m-%d-%a',
    --     time_format = '%H:%M',
    --   },
    completion = {
      -- Set to false to disable completion.
      nvim_cmp = true,
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    --    config = function ()
    --      require('which-key').register( ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
    -- )
    --    end,
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ["gf"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ["<leader>ch"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ["<cr>"] = {
        action = function()
          return require("obsidian").util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
    notes_subdir = "fresh",
    new_notes_location = "notes_subdir",
    note_id_func = function(title)
      -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
      -- In this case a note with the title 'My new note' will be given an ID that looks
      -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
      local suffix = ""
      if title ~= nil then
        -- If title is given, transform it into valid file name.
        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      else
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return suffix
    end,

    -- Optional, customize how wiki links are formatted.
    ---@param opts {path: string, label: string, id: string|?}
    ---@return string
    wiki_link_func = function(opts)
      if opts.id == nil then
        return string.format("[[%s]]", opts.label)
      elseif opts.label ~= opts.id then
        return string.format("[[%s|%s]]", opts.id, opts.label)
      else
        return string.format("[[%s]]", opts.id)
      end
    end,

    -- Optional, customize how markdown links are formatted.
    ---@param opts {path: string, label: string, id: string|?}
    ---@return string
    markdown_link_func = function(opts)
      return string.format("[%s](%s)", opts.label, opts.path)
    end,

    -- Either 'wiki' or 'markdown'.
    preferred_link_style = "wiki",

    -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
    ---@return string
    image_name_func = function()
      -- Prefix image names with timestamp.
      return string.format("%s-", os.time())
    end,

    -- Optional, boolean or a function that takes a filename and returns a boolean.
    -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
    disable_frontmatter = true,

    -- Optional, alternatively you can customize the frontmatter data.
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then
        note:add_alias(note.title)
      end

      local out = { id = note.id, aliases = note.aliases, tags = note.tags }

      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end

      return out
    end,

    -- Optional, for templates (see below).
    templates = {
      subdir = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
      -- A map for custom variables, the key should be the variable and the value a function
      substitutions = {},
    },

    -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
    -- URL it will be ignored but you can customize this behavior here.
    ---@param url string
    follow_url_func = function(url)
      -- vim.fn.jobstart({ "open", url }) -- Mac OS
      vim.fn.jobstart({ "brave", "--new-window", url }) -- linux // create a defaults folder in ~/config/ repo some day
    end,
    -- Optional, set to true if you use the Obsidian Advanced URI plugin.
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = false,
    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
    open_app_foreground = false,
    picker = {
      -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
      name = "telescope.nvim",
      -- Optional, configure key mappings for the picker. These are the defaults.
      -- Not all pickers support all mappings.
      mappings = {
        -- Create a new note from your query.
        new = "<C-x>",
        -- Insert a link to the selected note.
        insert_link = "<C-l>",
      },
    },
    -- Optional, sort search results by "path", "modified", "accessed", or "created".
    -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
    -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
    sort_by = "modified",
    sort_reversed = true,
    -- Optional, determines how certain commands open notes. The valid options are:
    -- 1. "current" (the default) - to always open in the current window
    -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
    -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
    open_notes_in = "current",
    -- Optional, configure additional syntax highlighting / extmarks.
    -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
    conceallevel = 2,
    -- Specify how to handle attachments.
    attachments = {
      -- The default folder to place images in via `:ObsidianPasteImg`.
      -- If this is a relative path it will be interpreted as relative to the vault root.
      -- You can always override this per image by passing a full path to the command instead of just a filename.
      img_folder = "assets/imgs", -- This is the default
      -- A function that determines the text to insert in the note when pasting an image.
      -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
      -- This is the default implementation.
      ---@param client obsidian.Client
      ---@param path obsidian.Path the absolute path to the image file
      ---@return string
      img_text_func = function(client, path)
        path = client:vault_relative_path(path) or path
        return string.format("![%s](%s)", path.name, path)
      end,
    },
  },
}

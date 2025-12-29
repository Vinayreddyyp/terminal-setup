return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Safe require
    local ok, oil = pcall(require, "oil")
    if not ok or not oil then
      return
    end

    -- Setup oil with float options
    oil.setup({
      view_options = {
        show_hidden = false,
        is_hidden_file = function(name, bufnr)
          return vim.fn.match(name, "^%.") ~= -1 -- treat dotfiles as hidden
        end,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 0,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
      },
      replace_netrw = true,
      delete_to_trash = false,
    })

    -- Keymaps
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Toggle floating Oil for parent of current file
    map("n", "-", function()
      pcall(function()
        oil.toggle_float()
      end)
    end, vim.tbl_extend("keep", { desc = "Oil: toggle float (parent dir)" }, opts))

    -- Open floating Oil for parent dir (explicit)
    map("n", "<leader>fo", function()
      pcall(function()
        oil.open_float()
      end)
    end, vim.tbl_extend("keep", { desc = "Oil: open float (parent dir)" }, opts))

    -- Open floating Oil for cwd explicitly
    map("n", "<leader>fd", function()
      pcall(function()
        oil.open_float(vim.loop.cwd())
      end)
    end, vim.tbl_extend("keep", { desc = "Oil: open float (cwd)" }, opts))

    ----------------------------------------------------------------
    -- Statusline indicator
    --
    -- Provide a tiny module accessible at v:lua.require('oil_float_status')
    -- so the statusline can call it. We also try to append a global
    -- fallback to 'vim.o.statusline' so users who don't use lualine/heirline
    -- will see it automatically.
    ----------------------------------------------------------------
    local status_mod = {}

    -- return true if any visible window contains an Oil buffer
    function status_mod.is_oil_open()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.api.nvim_buf_get_option(buf, "filetype")
        if ft == "oil" then
          return true
        end
      end
      return false
    end

    -- Statusline component (string). Called from statusline via v:lua.
    -- Return either empty string or the indicator text.
    function status_mod.statusline_component()
      if status_mod.is_oil_open() then
        -- you can change the text/icon here (e.g. use a devicon)
        return " [Oil] "
      end
      return ""
    end

    -- Expose module globally (so v:lua can call it)
    -- store it under package.loaded to make require work
    package.loaded["oil_float_status"] = status_mod

    ----------------------------------------------------------------
    -- Try to append a small snippet to vim.o.statusline as a fallback.
    -- This will not override a user's custom statusline if they already
    -- set a complex statusline plugin that replaces vim.o.statusline.
    ----------------------------------------------------------------
    local snippet = "%{v:lua.require'oil_float_status'.statusline_component()}"

    -- Append snippet only if it's not already present
    local cur = vim.o.statusline or ""
    if not string.find(cur, "oil_float_status", 1, true) then
      -- We'll append the indicator at the right side. Use %= to push it right.
      -- If statusline is empty, use the snippet directly.
      if cur == "" then
        vim.o.statusline = snippet
      else
        -- Append with a spacer and right-align
        vim.o.statusline = cur .. "%=%=" .. snippet
      end
    end

    ----------------------------------------------------------------
    -- Optional: small command to print how to open Oil and the keymaps
    ----------------------------------------------------------------
    vim.api.nvim_create_user_command("OilHelp", function()
      print("Oil floating shortcuts:")
      print("  -            : toggle floating Oil for parent dir")
      print("  <leader>fo   : open floating Oil for current file's parent dir")
      print("  <leader>fd   : open floating Oil for current working directory")
      print("  :Oil --float [path]  : open a float for path (if you prefer commands)")
    end, { desc = "Show Oil float keymaps and usage" })
  end,
}

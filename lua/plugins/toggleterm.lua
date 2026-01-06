return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    direction = "float",
    start_in_insert = true,
    close_on_exit = true,
    shade_terminals = true,
    persist_size = true,
    persist_mode = true,
    float_opts = {
      border = "curved",
      width = 110,
      height = 30,
      winblend = 0,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    local Terminal = require("toggleterm.terminal").Terminal

    -- Tab-like terminal storage
    local terms = {}
    local current = 0

    local function open_term(i)
      if i < 1 then
        i = 1
      end

      if not terms[i] then
        terms[i] = Terminal:new({
          count = i, -- ✅ IMPORTANT: fixes "Terminal 1 shows as Terminal 2"
          direction = "float",
          close_on_exit = true,
        })
      end

      current = i
      terms[i]:toggle()
    end

    local function last_term_index()
      local last = 0
      for i = 1, 9999 do
        if terms[i] then
          last = i
        else
          break
        end
      end
      return last
    end

    -- Popup panel to pick a terminal tab
    local function pick_terminal()
      local last = last_term_index()
      if last == 0 then
        vim.notify("No terminals yet. Press <leader>tn to create one.", vim.log.levels.INFO)
        return
      end

      local items = {}
      for i = 1, last do
        table.insert(items, {
          label = ("Terminal %d%s"):format(i, (i == current and "  (current)" or "")),
          id = i,
        })
      end

      vim.ui.select(items, {
        prompt = "Select Terminal Tab",
        format_item = function(item)
          return item.label
        end,
      }, function(choice)
        if choice and choice.id then
          open_term(choice.id)
        end
      end)
    end

    -- <leader>tn → NEW terminal (like + tab)
    vim.keymap.set("n", "<leader>tn", function()
      local next_i = last_term_index() + 1
      open_term(next_i)
    end, { desc = "New Terminal Tab" })

    -- <leader>tl → NEXT terminal tab
    vim.keymap.set("n", "<leader>tl", function()
      local last = last_term_index()
      if last == 0 then
        open_term(1)
        return
      end

      local next_i = (current == 0) and 1 or (current + 1)
      if next_i > last then
        next_i = 1
      end
      open_term(next_i)
    end, { desc = "Next Terminal Tab" })

    -- <leader>th → PREVIOUS terminal tab
    vim.keymap.set("n", "<leader>th", function()
      local last = last_term_index()
      if last == 0 then
        open_term(1)
        return
      end

      local prev_i = (current == 0) and 1 or (current - 1)
      if prev_i < 1 then
        prev_i = last
      end
      open_term(prev_i)
    end, { desc = "Previous Terminal Tab" })

    -- <leader>ts → Show picker
    vim.keymap.set("n", "<leader>ts", pick_terminal, { desc = "Select Terminal Tab" })

    -- ✅ Make <leader>tt toggle your "current tab terminal" (NOT ToggleTerm default)
    vim.keymap.set("n", "<leader>tt", function()
      if current == 0 then
        -- if nothing created yet, open/create terminal 1
        open_term(1)
      else
        open_term(current)
      end
    end, { desc = "Toggle Current Terminal Tab" })

    vim.keymap.set("n", "<C-\\>", function()
      if current == 0 then
        open_term(1)
      else
        open_term(current)
      end
    end, { desc = "Toggle Current Terminal Tab" })

    -- ESC closes floating terminal
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*toggleterm#*",
      callback = function()
        vim.keymap.set("t", "<Esc>", [[<C-\><C-n><cmd>ToggleTerm<cr>]], {
          buffer = true,
          noremap = true,
          silent = true,
          desc = "Close ToggleTerm with Esc",
        })
      end,
    })
  end,
}

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
      if not terms[i] then
        terms[i] = Terminal:new({
          direction = "float",
          close_on_exit = true,
        })
      end
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
          current = choice.id
          open_term(current)
        end
      end)
    end

    -- <leader>tn → NEW terminal (like + tab)
    vim.keymap.set("n", "<leader>tn", function()
      current = current + 1
      open_term(current)
    end, { desc = "New Terminal Tab" })

    -- <leader>tl → NEXT terminal tab
    vim.keymap.set("n", "<leader>tl", function()
      if current == 0 then
        current = 1
        open_term(current)
        return
      end

      local next_i = current + 1
      if not terms[next_i] then
        next_i = 1 -- wrap
      end
      current = next_i
      open_term(current)
    end, { desc = "Next Terminal Tab" })

    -- <leader>th → PREVIOUS terminal tab
    vim.keymap.set("n", "<leader>th", function()
      if current == 0 then
        current = 1
        open_term(current)
        return
      end

      local prev_i = current - 1
      if prev_i < 1 then
        prev_i = math.max(1, last_term_index()) -- wrap to last
      end
      current = prev_i
      open_term(current)
    end, { desc = "Previous Terminal Tab" })

    -- <leader>ts → Show "panel" picker to jump to any terminal
    vim.keymap.set("n", "<leader>ts", pick_terminal, { desc = "Select Terminal Tab" })

    -- Toggle last used terminal
    vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", {
      desc = "Toggle Floating Terminal",
    })
    vim.keymap.set("n", "<C-\\>", "<cmd>ToggleTerm direction=float<cr>", {
      desc = "Toggle Floating Terminal",
    })

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

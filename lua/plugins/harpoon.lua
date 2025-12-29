-- ~/.config/nvim/lua/plugins/harpoon.lua
-- Lazy.nvim plugin spec for Harpoon (harpoon2) with silent keymaps

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local ok, harpoon = pcall(require, "harpoon")
    if not ok then
      return
    end

    harpoon.setup({
      global_settings = {
        save_on_change = true,
        save_on_toggle = false,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
      },
    })

    local mark_ok, mark = pcall(require, "harpoon.mark")
    local ui_ok, ui = pcall(require, "harpoon.ui")
    if not mark_ok or not ui_ok then
      return
    end

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Add current file
    map("n", "<leader>ha", function()
      mark.add_file()
    end, vim.tbl_extend("keep", { desc = "Harpoon: Add file" }, opts))

    -- Remove current file
    map("n", "<leader>hr", function()
      mark.rm_file()
    end, vim.tbl_extend("keep", { desc = "Harpoon: Remove file" }, opts))

    -- Toggle add/remove current file
    map("n", "<leader>ht", function()
      mark.toggle_file()
    end, vim.tbl_extend("keep", { desc = "Harpoon: Toggle file" }, opts))

    -- Show Harpoon list
    map("n", "<leader>hh", function()
      ui.toggle_quick_menu()
    end, vim.tbl_extend("keep", { desc = "Harpoon: List" }, opts))

    -- Jump to files 1–9
    for i = 1, 9 do
      map("n", ("<leader>h%d"):format(i), function()
        pcall(ui.nav_file, i)
      end, vim.tbl_extend("keep", { desc = ("Harpoon: Go to %d"):format(i) }, opts))
    end
  end,
}

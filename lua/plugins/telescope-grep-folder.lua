return {
  "nvim-telescope/telescope.nvim",
  keys = {
    {
      "<leader>sf",
      function()
        require("telescope.builtin").live_grep({
          prompt_title = "Live Grep (Folder Only)",
          search_dirs = { vim.fn.expand("%:p:h") },
        })
      end,
      desc = "Live Grep in current folder",
    },
  },
}

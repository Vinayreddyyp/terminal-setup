return {
  {
    "aserowy/tmux.nvim",
    opts = {
      -- Disable defaults so our mappings are the only source of truth
      navigation = { enable_default_keybindings = false },
      resize = { enable_default_keybindings = false },
    },

    keys = {
      -- ─────────────────────────────
      -- Sessions
      -- ─────────────────────────────
      {
        "<leader>am",
        function()
          vim.cmd("silent !tmux choose-tree -Zs")
        end,
        desc = "Tmux: Session menu",
      },
      {
        "<leader>as",
        function()
          vim.cmd(
            [[silent !tmux has-session -t dev 2>/dev/null && tmux switch-client -t dev || tmux new-session -A -s dev]]
          )
        end,
        desc = "Tmux: Switch/Create dev session",
      },

      -- ─────────────────────────────
      -- Windows (tabs)
      -- ─────────────────────────────
      {
        "<leader>ac",
        function()
          vim.cmd("silent !tmux new-window")
        end,
        desc = "Tmux: New window",
      },
      {
        "<leader>a]",
        function()
          vim.cmd("silent !tmux next-window")
        end,
        desc = "Tmux: Next window",
      },
      {
        "<leader>a[",
        function()
          vim.cmd("silent !tmux previous-window")
        end,
        desc = "Tmux: Previous window",
      },
      {
        "<leader>aw",
        function()
          vim.cmd("silent !tmux choose-window")
        end,
        desc = "Tmux: Window picker",
      },

      -- ─────────────────────────────
      -- Panes (splits) - create
      -- ─────────────────────────────
      {
        "<leader>a|",
        function()
          vim.cmd("silent !tmux split-window -h")
        end,
        desc = "Tmux: Vertical split",
      },
      {
        "<leader>a-",
        function()
          vim.cmd("silent !tmux split-window -v")
        end,
        desc = "Tmux: Horizontal split",
      },
      {
        "<leader>az",
        function()
          vim.cmd("silent !tmux resize-pane -Z")
        end,
        desc = "Tmux: Toggle full screen pane",
      },

      -- ─────────────────────────────
      -- Panes (splits) - navigate
      -- ─────────────────────────────
      {
        "<leader>ah",
        function()
          vim.cmd("silent !tmux select-pane -L")
        end,
        desc = "Tmux: Pane left",
      },
      {
        "<leader>al",
        function()
          vim.cmd("silent !tmux select-pane -R")
        end,
        desc = "Tmux: Pane right",
      },
      {
        "<leader>ak",
        function()
          vim.cmd("silent !tmux select-pane -U")
        end,
        desc = "Tmux: Pane up",
      },
      {
        "<leader>aj",
        function()
          vim.cmd("silent !tmux select-pane -D")
        end,
        desc = "Tmux: Pane down",
      },

      -- ─────────────────────────────
      -- Panes (splits) - resize
      -- ─────────────────────────────
      {
        "<leader>a<Left>",
        function()
          vim.cmd("silent !tmux resize-pane -L 5")
        end,
        desc = "Tmux: Resize pane left",
      },
      {
        "<leader>a<Right>",
        function()
          vim.cmd("silent !tmux resize-pane -R 5")
        end,
        desc = "Tmux: Resize pane right",
      },
      {
        "<leader>a<Up>",
        function()
          vim.cmd("silent !tmux resize-pane -U 3")
        end,
        desc = "Tmux: Resize pane up",
      },
      {
        "<leader>a<Down>",
        function()
          vim.cmd("silent !tmux resize-pane -D 3")
        end,
        desc = "Tmux: Resize pane down",
      },
    },
  },
}

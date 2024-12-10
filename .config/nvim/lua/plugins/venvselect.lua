return {
  "linux-cultist/venv-selector.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python", --optional
    { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  branch = "regexp", -- This is the regexp branch, use this for the new version
  config = function()
    local wk = require("which-key")
    wk.register({
      ["<leader>v"] = { name = "[V]env", _ = "which_key_ignore", c = { "<cmd>VenvSelect<CR>", "Select VirtualEnv" } },
    })
    require("venv-selector").setup({
      settings = {
        search = {
          my_venvs = {
            command = "fd python$ ~/venv/*/bin",
          },
        },
      },
    })
  end,
  ft = "python",
  -- keys = {
  --   { '<leader>vc', '<cmd>VenvSelect<cr>', desc = 'Select VirtualEnv', ft = 'python' },
  --   { '<leader>v', _, desc = 'Venv', ft = 'python' },
  -- },
}

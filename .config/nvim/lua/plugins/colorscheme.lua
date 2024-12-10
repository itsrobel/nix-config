return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "moon",
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats = "transparent",
      keywords = { italic = true },
      comments = { bold = true },
      functions = { italic = true },
      variables = { italic = false },
    },
  },

  init = function()
    vim.cmd.colorscheme("tokyonight")
  end,
}

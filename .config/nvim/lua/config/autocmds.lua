-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local function check_clipboard()
  if vim.fn.executable("wl-copy") == 0 then
    vim.notify("wl-clipboard is not installed.", vim.log.levels.WARN)
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = check_clipboard,
})

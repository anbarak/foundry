-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- ─────────────────────────────────────────────────────────────────────────────
-- Auto-reload files changed externally (e.g. by Claude Code editing files)
-- ─────────────────────────────────────────────────────────────────────────────
-- `autoread` tells Neovim to read a file that has changed outside the buffer,
-- but it only fires on specific events — not continuously. These autocmds
-- trigger `:checktime` at the right moments so reloads actually happen.

vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("auto_reload_files", { clear = true }),
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.bufname() ~= "[Command Line]" then
      vim.cmd("checktime")
    end
  end,
  desc = "Reload files changed externally (Claude Code, git pull, etc.)",
})

-- Notify when a file was reloaded automatically
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = vim.api.nvim_create_augroup("auto_reload_notify", { clear = true }),
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk — buffer reloaded", vim.log.levels.INFO)
  end,
  desc = "Notify on external file reload",
})

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

-- Per-filetype colorcolumn overrides
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.opt_local.colorcolumn = "88"
  end, -- black default
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "terraform", "hcl", "go" },
  callback = function()
    vim.opt_local.colorcolumn = "120"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "gitcommit", "json", "jsonc" },
  callback = function()
    vim.opt_local.colorcolumn = ""
  end, -- disable
})

-- ColorColumn: subtle tint that survives colorscheme reloads
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#504945" }) -- gruvbox-material bg3
  end,
})

-- Apply immediately for the current session too
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#504945" })

-- Disable format-on-save for shell scripts
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "bash" },
  callback = function()
    vim.b.autoformat = false
  end,
})

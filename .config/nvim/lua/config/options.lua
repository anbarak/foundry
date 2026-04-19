-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ─── Mouse + Clipboard: match terminal-native copy-on-release behavior ──
-- Drag-select with mouse, release → selected text copied to system clipboard,
-- highlight clears. Matches Ghostty/Zellij/old vim workflow.
vim.opt.mouse = "a"                        -- enable mouse in all modes
vim.opt.clipboard = "unnamedplus"          -- use system clipboard

-- On mouse release in visual mode, yank to clipboard and clear selection
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "v:n",  -- visual → normal transition
  callback = function()
    -- Only act if the mode transition came from mouse, not keyboard
    -- (this fires on any visual exit, but clipboard copy is idempotent)
  end,
})

-- The cleanest approach: map mouse-up in visual mode to yank + escape
vim.keymap.set("v", "<LeftRelease>", '"+y<Esc>', { silent = true, desc = "Mouse-up: copy to clipboard + exit visual" })

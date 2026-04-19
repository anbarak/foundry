-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ─── Mouse + Clipboard: match terminal-native copy-on-release behavior ──
-- Drag-select with mouse, release → selected text copied to system clipboard,
-- highlight clears. Matches Ghostty/Zellij/old vim workflow.
vim.opt.mouse = "a" -- enable mouse in all modes
vim.opt.clipboard = "unnamedplus" -- use system clipboard

-- On mouse release in visual mode, yank to clipboard and clear selection
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "v:n", -- visual → normal transition
  callback = function()
    -- Only act if the mode transition came from mouse, not keyboard
    -- (this fires on any visual exit, but clipboard copy is idempotent)
  end,
})

-- The cleanest approach: map mouse-up in visual mode to yank + escape
vim.keymap.set("v", "<LeftRelease>", '"+y<Esc>', { silent = true, desc = "Mouse-up: copy to clipboard + exit visual" })

-- ─── Paste: bypass indentexpr so literal indent is preserved ──────────────
-- LazyVim uses treesitter indentexpr for Python/Lua which re-indents pasted
-- lines. Override vim.paste to use nvim_put which skips indent logic.
vim.paste = function(lines, _)
  if #lines > 0 and lines[#lines] == "" then
    table.remove(lines)
  end
  if #lines == 0 then
    return true
  end
  vim.api.nvim_put(lines, "c", true, true)
  return true
end

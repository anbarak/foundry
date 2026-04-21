-- Options are automatically loaded before lazy.nvim startup
-- LazyVim defaults: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- This file adds/overrides on top of those.

-- ─── Mouse + Clipboard ──────────────────────────────────────────────────
-- Drag-select with mouse, release copies selection to system clipboard and
-- exits visual mode. Matches Ghostty/Zellij/old-vim muscle memory.
vim.opt.mouse = "a"
vim.opt.mousescroll = "ver:10,hor:6" -- 10 lines per vertical scroll tick
vim.opt.clipboard = "unnamedplus" -- always use system clipboard

-- Mouse-up in visual mode: copy to clipboard + exit visual
vim.keymap.set("v", "<LeftRelease>", '"+y<Esc>', {
  silent = true,
  desc = "Mouse-up: copy to clipboard + exit visual",
})

-- Shift+scroll pans the viewport without moving cursor or extending selection.
-- Use this when you need to scroll during a click-drag selection:
--   1. Click where selection starts
--   2. Shift+scroll to bring the end point into view (cursor stays put)
--   3. Shift-click the end point to extend selection in one shot
vim.keymap.set({ "n", "v", "i" }, "<S-ScrollWheelUp>", "10<C-y>")
vim.keymap.set({ "n", "v", "i" }, "<S-ScrollWheelDown>", "10<C-e>")

-- ─── Paste: preserve literal indentation ────────────────────────────────
-- LazyVim's treesitter indentexpr (Python/Lua/etc.) re-indents pasted lines.
-- Override vim.paste to use nvim_put which skips indent logic entirely.
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

-- ─── Editing quality-of-life ────────────────────────────────────────────
vim.opt.colorcolumn = "100" -- soft line-length guide
vim.opt.scrolloff = 8 -- keep 8 lines of context above/below cursor
vim.opt.sidescrolloff = 8 -- same for horizontal scroll
vim.opt.confirm = true -- ask to save instead of erroring on :q with unsaved changes
vim.opt.undofile = true -- persistent undo across restarts
vim.opt.ignorecase = true -- case-insensitive search...
vim.opt.smartcase = true -- ...unless the query has uppercase
vim.opt.splitright = true -- :vsplit opens to the right (predictable)
vim.opt.splitbelow = true -- :split opens below (predictable)

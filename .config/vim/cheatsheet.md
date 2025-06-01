# 🧠 Vim Cheatsheet – Personal Hotlist

## ✴️ Modes
- `i` – insert
- `a` – append
- `v`, `V`, `Ctrl-v` – visual modes
- `Esc` – return to normal mode
- `:` – command mode

## 🚶 Movement
- `h j k l` – left down up right
- `w`, `b`, `e` – word jumps
- `gg`, `G`, `{`, `}` – top, bottom, paragraph
- `0`, `^`, `$` – line start (soft/hard), end

## ✂️ Editing
- `x` – delete character
- `dd`, `yy`, `p`, `P` – delete line, yank, paste
- `u`, `Ctrl-r` – undo, redo
- `cw`, `caw`, `ci"` – change word, a word, inside quotes
- `daw`, `di(` – delete a word, delete inside parens
- `J` – join lines

## 🔍 Search & Replace
- `/text`, `n`, `N` – search forward/backward
- `:%s/old/new/gc` – find & replace

## 🪟 Windows & Buffers
- `:split`, `:vsplit` – split windows
- `Ctrl-w h/j/k/l` – move between windows
- `:bnext`, `:bprev`, `:ls`, `:bd` – buffer commands

## 📋 Registers
- `"0p` – last yank
- `"*p` – system clipboard
- `:reg` – view registers

## ⏱️ Leader Shortcuts (if using one)
- `<leader>w` → save
- `<leader>q` → quit
- `<leader>f` → telescope file search (with plugin)

## 🔤 Spellcheck & Suggestions
- `z=` → show spelling suggestions
- `<number>` + `Enter` → select suggestion from the list
- `]s` → move to next misspelled word
- `[s` → move to previous misspelled word

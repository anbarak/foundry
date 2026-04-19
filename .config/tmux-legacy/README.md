# tmux-legacy archive

Archived 2026-04-18 when Phase 8 of the dev env migration replaced tmux with Zellij.

## Contents

- `tmux.conf` — the main tmux configuration (originally `~/.tmux.conf`)
- `15-tmux.zsh` — zsh aliases and functions for tmux (`ts`, `ta`, `tn`, etc.)
- `18-jenkins.zsh` — Jenkins helper module (tmux-dependent, unused, archived rather than refactored)
- `tmux-start` — smart attach/start/restore script (originally `~/bin/dev/tmux-start`)
- `tmux-powerline/` — powerline config (already dead code before archival; native tmux status replaced it earlier)
- `99-custom-tmux-refs.txt` — tmux aliases from custom module (edit_tmux, src_tmux)
- `sessions-snapshot.txt` — snapshot of active tmux sessions at time of migration

## Purpose

Kept for reference in case Zellij needs behavior replicated or a missing feature
identified. Not meant to be used — tmux is no longer installed.

## To restore Jenkins helpers

If you ever need the Jenkins helpers again, refactor `18-jenkins.zsh` to use
`zellij action new-tab` and `zellij action go-to-tab-name` instead of the tmux
equivalents. Then move it back to `~/.config/zsh/modules/`.

## To fully purge

If you want to reclaim the space:
    rm -rf ~/.config/tmux-legacy

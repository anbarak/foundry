# mise - runtime version manager (replaces asdf for per-dir tool versions)
if command -v mise >/dev/null 2>&1; then
  add_to_path "$HOME/.local/share/mise/shims"
fi

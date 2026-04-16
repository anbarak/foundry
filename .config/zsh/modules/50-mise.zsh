# mise - runtime version manager (replaces asdf for per-dir tool versions)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

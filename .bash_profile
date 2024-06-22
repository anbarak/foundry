export PATH="/opt/homebrew/bin:$PATH"  # For Apple Silicon Macs

if [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/hossein/google-cloud-sdk/path.bash.inc' ]; then . '/Users/hossein/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/hossein/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/hossein/google-cloud-sdk/completion.bash.inc'; fi

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi

# WSL-specific configurations
if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  # WSL2 clipboard integration
  alias pbcopy='clip.exe'
  alias pbpaste='powershell.exe Get-Clipboard | tr -d "\r"'

  # Keep paths in WSL filesystem for performance
  export DOCKER_HOST=unix:///var/run/docker.sock
fi

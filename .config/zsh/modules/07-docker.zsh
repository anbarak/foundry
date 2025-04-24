# shellcheck shell=bash
# =============================================================================
# Docker
# =============================================================================
### ── Docker CLI Shortcuts ─────────────────────────────
alias d="docker"
alias dc="docker compose"
alias dps="docker ps -a"
alias dimg="docker images"
alias dstats="docker stats"
alias dexec="docker exec -it"  # Usage: dexec <container> bash
alias dlog="docker logs -f"    # Usage: dlog <container>
alias dnet="docker network ls"
alias dvol="docker volume ls"

### ── Docker Cleanup Shortcuts ─────────────────────────
alias docker-clean-all='
  echo "Stopping all containers...";
  docker stop $(docker ps -aq) 2>/dev/null;
  echo "Removing all containers...";
  docker rm $(docker ps -aq) 2>/dev/null;
  echo "Removing all images...";
  docker rmi $(docker images -q) 2>/dev/null;
  echo "Pruning unused resources...";
  docker system prune -f;
'

### ── Colima Management ────────────────────────────────
alias colima-start="colima start --cpu 2 --memory 2 --disk 20"
alias colima-stop="colima stop"
alias colima-restart="colima stop && colima start"
alias colima-status="colima status"

### ── Kubernetes Context (if using Colima k3s) ─────────
alias kctx-colima="kubectl config use-context colima"

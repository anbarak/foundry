# =============================================================================
# Docker
# =============================================================================
alias dk='docker'
alias dkb='docker build'
alias dkc='docker-compose'
alias dki='docker images'
alias dkp='docker ps'
alias dkpa='docker ps -a'
alias dkr='docker run'
alias dkrm='docker rm'
alias dkrmi='docker rmi'
alias dkl='docker logs'
alias docker_stop_all='docker stop $(docker ps -aq)'
alias docker_rm_all='read -p "Remove all containers? (y/n) " yn && [[ $yn == "y" ]] && docker rm $(docker ps -aq)'
alias docker_rmi_all='docker rmi $(docker images -q)'
alias docker_prune='docker system prune -af'
alias docker_restart_all='docker restart $(docker ps -aq)'

docker-clean-all() {
  echo "Stopping all containers..."
  docker stop $(docker ps -aq)
  echo "Removing all containers..."
  docker rm $(docker ps -aq)
  echo "Removing all images..."
  docker rmi $(docker images -q)
  echo "Pruning unused resources..."
  docker system prune -af
}

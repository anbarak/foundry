# Jenkins Master Nodes
alias j2='ssh ubuntu@jenkins02-master'
alias j3="open $HOME/.config/rdp/jenkins03-master.rdp"  # Windows RDP
# Add j4 and others as needed...

# Jenkins Build Agents
j3a5() {
  local session="j3a5"
  local script="$HOME/bin/runners/helpers/jenkins/ssh-agent.sh cf-dockerprodlax05.centerfield.com"

  if [ -z "$TMUX" ]; then
    tmux new -As "$session" "$script"
  else
    if tmux has-session -t "$session" 2>/dev/null; then
      tmux switch-client -t "$session"
    else
      tmux new-session -ds "$session" "zsh -i -c '$script; exec zsh'"
      tmux switch-client -t "$session"
    fi
  fi
}
j3a6() {
  local session="j3a6"
  local script="$HOME/bin/runners/helpers/jenkins/ssh-agent.sh cf-dockerprodlax06.centerfield.com"

  if [ -z "$TMUX" ]; then
    tmux new -As "$session" "$script"
  else
    if tmux has-session -t "$session" 2>/dev/null; then
      tmux switch-client -t "$session"
    else
      tmux new-session -ds "$session" "$script"
      tmux switch-client -t "$session"
    fi
  fi
}
j3a7() {
  local session="j3a7"
  local script="$HOME/bin/runners/helpers/jenkins/ssh-agent.sh cf-dockerprodlax07.centerfield.com"

  if [ -z "$TMUX" ]; then
    tmux new -As "$session" "$script"
  else
    if tmux has-session -t "$session" 2>/dev/null; then
      tmux switch-client -t "$session"
    else
      tmux new-session -ds "$session" "zsh -i -c '$script; exec zsh'"
      tmux switch-client -t "$session"
    fi
  fi
}
j3a8() {
  local session="j3a8"
  local script="$HOME/bin/runners/helpers/jenkins/ssh-agent.sh cf-dockerprodlax08.centerfield.com"

  if [ -z "$TMUX" ]; then
    tmux new -As "$session" "$script"
  else
    if tmux has-session -t "$session" 2>/dev/null; then
      tmux switch-client -t "$session"
    else
      tmux new-session -ds "$session" "zsh -i -c '$script; exec zsh'"
      tmux switch-client -t "$session"
    fi
  fi
}

# Quick one-off SSH (optional)
alias j3a5s="$HOME/bin/runners/helpers/jenkins/ssh-agent.sh cf-dockerprodlax05.centerfield.com"
alias j3a6s="$HOME/bin/runners/helpers/jenkins/ssh-agent.sh cf-dockerprodlax06.centerfield.com"
alias j3a7s="$HOME/bin/runners/helpers/jenkins/ssh-agent.sh cf-dockerprodlax07.centerfield.com"
alias j3a8s="$HOME/bin/runners/helpers/jenkins/ssh-agent.sh cf-dockerprodlax08.centerfield.com"

# List all Jenkins-related tmux sessions
alias jls='tmux ls | grep j3a'

# Kill all Jenkins tmux agent sessions (use carefully)
alias jkill-all='tmux ls | grep j3a | cut -d: -f1 | xargs -n1 tmux kill-session -t'

# Jenkins workspace cleaner (example placeholder)
# alias jclean='ssh ubuntu@j3a5 "rm -rf /var/lib/jenkins/workspace/*"'  # Customize this per host

# Jenkins logs (customize if needed)
# alias jlogs='ssh ubuntu@j3a5 "tail -f /var/log/jenkins/jenkins.log"'

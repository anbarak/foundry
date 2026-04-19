# =============================================================================
# 23-todo.zsh — todo-txt (todo.sh) configuration and aliases
# =============================================================================
#
# Config file: ~/.config/todo/config
# Data files:  ~/.config/todo/{todo,done,report}.txt
#
# Usage cheatsheet:
#   t add "task"          add a task
#   t add "(A) task"      add with priority A
#   t ls                  list open tasks
#   t lsa                 list all (open + done)
#   t do N                mark task N complete
#   t pri N A             set priority of task N to A
#   t depri N             remove priority
#   t edit                open todo.txt in $EDITOR
#   t archive             move done items to done.txt
#
# todo.txt syntax:
#   (A) Priority A task
#   task +project @context      projects prefixed +, contexts prefixed @
#   task due:2026-04-30         extensions as key:value
# =============================================================================

# Point todo.sh at XDG config location (default is ~/.todo.cfg)
export TODOTXT_CFG_FILE="$HOME/.config/todo/config"

# Aliases
alias t='todo.sh'
alias ta='todo.sh add'
alias tl='todo.sh ls'
alias tll='todo.sh lsa'          # list all, including done
alias tdo='todo.sh do'           # mark complete
alias tp='todo.sh pri'           # set priority: tp 3 A
alias tdp='todo.sh depri'        # remove priority
alias te='todo.sh edit'          # open todo.txt in $EDITOR
alias tarch='todo.sh archive'    # move done items to done.txt

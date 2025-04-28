# shellcheck shell=bash
# Prints current branch in a VCS directory with color status (clean, modified, conflict).

# Source lib to get the function get_tmux_pwd
# shellcheck source=/dev/null
source "${TMUX_POWERLINE_DIR_LIB}/tmux_adapter.sh"
# shellcheck source=/dev/null
source "${TMUX_POWERLINE_DIR_LIB}/vcs_helper.sh"

TMUX_POWERLINE_SEG_VCS_BRANCH_MAX_LEN="${TMUX_POWERLINE_SEG_VCS_BRANCH_MAX_LEN:-15}"
TMUX_POWERLINE_SEG_VCS_BRANCH_TRUNCATE_SYMBOL="${TMUX_POWERLINE_SEG_VCS_BRANCH_TRUNCATE_SYMBOL:-…}"
TMUX_POWERLINE_SEG_VCS_BRANCH_DEFAULT_SYMBOL="${TMUX_POWERLINE_SEG_VCS_BRANCH_DEFAULT_SYMBOL:-}"

# Colors
TMUX_POWERLINE_SEG_VCS_BRANCH_CLEAN_COLOR="2"     # Green
TMUX_POWERLINE_SEG_VCS_BRANCH_DIRTY_COLOR="3"      # Yellow
TMUX_POWERLINE_SEG_VCS_BRANCH_CONFLICT_COLOR="1"   # Red
TMUX_POWERLINE_SEG_VCS_BRANCH_DEFAULT_COLOR="7"    # White if unknown

generate_segmentrc() {
  read -r -d '' rccontents <<EORC
# Max length of the branch name
export TMUX_POWERLINE_SEG_VCS_BRANCH_MAX_LEN="${TMUX_POWERLINE_SEG_VCS_BRANCH_MAX_LEN}"
# Truncate symbol
export TMUX_POWERLINE_SEG_VCS_BRANCH_TRUNCATE_SYMBOL="${TMUX_POWERLINE_SEG_VCS_BRANCH_TRUNCATE_SYMBOL}"
# Git clean/dirty/conflict colors
export TMUX_POWERLINE_SEG_VCS_BRANCH_CLEAN_COLOR="${TMUX_POWERLINE_SEG_VCS_BRANCH_CLEAN_COLOR}"
export TMUX_POWERLINE_SEG_VCS_BRANCH_DIRTY_COLOR="${TMUX_POWERLINE_SEG_VCS_BRANCH_DIRTY_COLOR}"
export TMUX_POWERLINE_SEG_VCS_BRANCH_CONFLICT_COLOR="${TMUX_POWERLINE_SEG_VCS_BRANCH_CONFLICT_COLOR}"
EORC
  echo "$rccontents"
}

run_segment() {
  local branch

  {
    read -r vcs_type
    read -r vcs_rootpath
  } < <(get_vcs_type_and_root_path)

  tmux_path=$(get_tmux_cwd)
  cd "$tmux_path" || return

  branch=$(__parse_"${vcs_type}"_branch "$vcs_rootpath")

  if [ -n "$branch" ]; then
    echo "${branch}"
  fi
  return 0
}

__parse_git_branch() {
  local branch
  local color="$TMUX_POWERLINE_SEG_VCS_BRANCH_DEFAULT_COLOR"
  local bg_color="4"

  # Quit if not a Git repo
  if ! branch=$(git symbolic-ref --short HEAD 2>/dev/null); then
    branch=$(git rev-parse --short HEAD 2>/dev/null) || return
  fi

  # Check Git status
  if git diff --quiet 2>/dev/null >&2 && git diff --cached --quiet 2>/dev/null >&2; then
    color="$TMUX_POWERLINE_SEG_VCS_BRANCH_CLEAN_COLOR"  # Clean
  elif git ls-files --unmerged | grep -q .; then
    color="$TMUX_POWERLINE_SEG_VCS_BRANCH_CONFLICT_COLOR"  # Merge conflicts
  else
    color="$TMUX_POWERLINE_SEG_VCS_BRANCH_DIRTY_COLOR"  # Dirty
  fi

  branch=$(__truncate_branch_name "$branch")
  echo "#[fg=colour${color},bg=colour${bg_color}]${TMUX_POWERLINE_SEG_VCS_BRANCH_DEFAULT_SYMBOL} ${branch}"
}

__truncate_branch_name() {
  local trunc_symbol branch
  trunc_symbol="$TMUX_POWERLINE_SEG_VCS_BRANCH_TRUNCATE_SYMBOL"
  branch="$1"

  if [ "${#branch}" -gt "$TMUX_POWERLINE_SEG_VCS_BRANCH_MAX_LEN" ]; then
    branch="${branch:0:$((TMUX_POWERLINE_SEG_VCS_BRANCH_MAX_LEN - ${#trunc_symbol}))}${trunc_symbol}"
  fi

  echo -n "$branch"
}

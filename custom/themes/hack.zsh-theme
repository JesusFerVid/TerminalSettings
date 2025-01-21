# Theme created from 'bira' and 'agnoster' themes
# Uses symbols from agnoster theme: #  ±  ➦ ✘ ⚡ ⚙
# And these, too: ▶ ➤ ᛘ ↪ ※ ↙ ↗ ✔

PROMPT_START_ICON="➤" # Suggested: ➤ ┌─── 

PROMPT_FAIL_ICON="✘"
PROMPT_SUPER_ICON="⚡"
PROMPT_BG_ICON="⚙"

PROMPT_USER_ICON="👤"
PROMPT_DEVICE_ICON="🖥️"
PROMPT_DIRECTORY_ICON="📂"


GIT_BRANCH_ICON="" # Suggested: ᛘ  
GIT_DETACHED_ICON="➦"
GIT_SYNCHED_ICON="✔"
GIT_PULL_ICON="↙"
GIT_PUSH_ICON="↗"
GIT_CLEAN_ICON="✔"
GIT_DIRTY_ICON="±"

VENV_PREFIX_ICON="<"
VENV_SUFFIX_ICON=">"

PROMPT_END_ICON="➤" # Suggested: ➤ "└▶ $"

PROMPT_SEPARATOR="      "

# Starting shape
prompt_start() {
	echo -n "$PROMPT_START_ICON "
}

# Symbols (failed command, root and background jobs)
prompt_status() {
	local -a symbols
	
	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$PROMPT_FAIL_ICON"
	[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}$PROMPT_SUPER_ICON"
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$PROMPT_BG_ICON"
	
	[[ -n "$symbols" ]] && echo -n "$symbols "
}

# User and host
prompt_context() {
	echo -n "$PROMPT_USER_ICON %B%{%F{5}%}%n "
	echo -n "$PROMPT_DEVICE_ICON  %B%{%F{5}%}%m$PROMPT_SEPARATOR"
}

# Working directory
prompt_dir() {
	# Directory string customization
	local full_path="%~"
	local current_dir="${PWD##*/}"

	echo -n "$PROMPT_DIRECTORY_ICON %B%{%F{blue}%}$current_dir$PROMPT_SEPARATOR"
}

# Git branch and working tree status
prompt_git() {
	if [ "$SHOW_GIT" = "TRUE" ] && [ "$HIDE_GIT" != "TRUE" ]; then
		if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]]; then
			echo -n "%{%F{yellow}%}"
			prompt_git_branch
			# prompt_git_worktree_status
			# prompt_git_upstream_status
			echo -n "%{$reset_color%"
		fi
	fi
	echo -n $PROMPT_SEPARATOR
}

prompt_git_branch() {
	if [[ "$(git rev-parse --symbolic-full-name HEAD 2> /dev/null)" = "HEAD" ]]; then
		echo -n "$GIT_DETACHED_ICON $(git rev-parse --short HEAD)"
	else
		echo -n "$GIT_BRANCH_ICON $(git branch --show-current)"
	fi
}

prompt_git_worktree_status(){
	git diff --quiet && echo -n "%{%F{green}%} $GIT_CLEAN_ICON" || echo -n "%{%F{red}%} $GIT_DIRTY_ICON"
	echo -n " "
}

# Auxiliar function to check if we need to pull and/or push
prompt_git_upstream_status() {
	if git rev-parse --abbrev-ref HEAD@{upstream} &> /dev/null; then
		git fetch -q

		local UPSTREAM=${1:-'@{u}'}
		local LOCAL=$(git rev-parse @)
		local REMOTE=$(git rev-parse "$UPSTREAM")
		local BASE=$(git merge-base @ "$UPSTREAM")

		if [ $LOCAL = $REMOTE ]; then
			echo -n "%{%F{cyan}%}$GIT_SYNCHED_ICON"
		elif [ $LOCAL = $BASE ]; then
			echo -n "%{%F{blue}%}$GIT_PULL_ICON"
		elif [ $REMOTE = $BASE ]; then
			echo -n "%{%F{green}%}$GIT_PUSH_ICON"
		else
			echo -n "%{%F{blue}%}$GIT_PULL_ICON%{%F{green}%}$GIT_PUSH_ICON"
		fi
	fi
}

# Virtual env
prompt_virtualenv() {
	ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{%F{green}%}$VENV_PREFIX_ICON"
	ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="$VENV_SUFFIX_ICON %{$reset_color%}"
	ZSH_THEME_VIRTUALENV_PREFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX"
	ZSH_THEME_VIRTUALENV_SUFFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"

	echo -n "$(virtualenv_prompt_info)$PROMPT_SEPARATOR"
}

# Ending shape and user symbol in new line
prompt_end() {
	echo ""
	echo -n "%{$reset_color%}$PROMPT_END_ICON  "
} 

# Create prompt string
build_prompt() {
	RETVAL=$?
	# prompt_start
	# prompt_status
	prompt_context
	prompt_dir
	prompt_git
	prompt_virtualenv
	prompt_end
}

# Show prompt
PROMPT='%{%f%b%k%}$(build_prompt)'
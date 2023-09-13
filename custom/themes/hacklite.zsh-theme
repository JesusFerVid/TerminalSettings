# Theme created from 'bira' and 'agnoster' themes
# Uses symbols from agnoster theme: #  ±  ➦ ✘ ⚡ ⚙
# And these, too: ▶ ➤ ᛘ ↪ ※ ↙ ↗ ✔

PROMPT_START_ICON="➤"
PROMPT_FAIL_ICON="✘"
PROMPT_SUPER_ICON="⚡"
PROMPT_BG_ICON="⚙"

GIT_BRANCH_ICON=""
GIT_DETACHED_ICON="➦"
GIT_SYNCHED_ICON="✔"
GIT_PULL_ICON="↙"
GIT_PUSH_ICON="↗"
GIT_CLEAN_ICON="✔"
GIT_DIRTY_ICON="±"

VENV_PREFIX_ICON="<"
VENV_SUFFIX_ICON=">"

PROMPT_END_ICON="$"

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
	echo -n "%B%{%F{5}%}%n@%m%{%F{reset_color}%}  "
}

# Working directory
prompt_dir() {
	# Directory string customization
	local full_path="%~"
	local current_dir="${PWD##*/}"

	echo -n "%B%{$fg[blue]%}$current_dir%{$reset_color%}  "
}

# Auxiliar function to check if we need to pull and/or push
git_upstream_status() {
	if [[ $SHOW_GIT = 'TRUE' ]]; then
		if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]]; then
			if git rev-parse --abbrev-ref HEAD@{upstream} &> /dev/null; then
				git fetch -q

				UPSTREAM=${1:-'@{u}'}
				LOCAL=$(git rev-parse @)
				REMOTE=$(git rev-parse "$UPSTREAM")
				BASE=$(git merge-base @ "$UPSTREAM")

				if [ $LOCAL = $REMOTE ]; then
					echo -n "%{$fg[cyan]%}$GIT_SYNCHED_ICON"
				elif [ $LOCAL = $BASE ]; then
					echo -n "%{$fg[blue]%}$GIT_PULL_ICON"
				elif [ $REMOTE = $BASE ]; then
					echo -n "%{$fg[green]%}$GIT_PUSH_ICON"
				else
					echo -n "%{$fg[blue]%}$GIT_PULL_ICON%{$fg[green]%}$GIT_PUSH_ICON"
				fi
			fi
		fi
	fi
}

# Git branch and working tree status
prompt_git() {
	if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]]; then
		if [[ "$(git rev-parse --symbolic-full-name HEAD 2> /dev/null)" = "HEAD" ]]; then
			ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}$GIT_DETACHED_ICON "
		else
			ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}$GIT_BRANCH_ICON "
		fi
	fi

	ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} $GIT_CLEAN_ICON"
	ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} $GIT_DIRTY_ICON"
	ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%} $(git_upstream_status)%{$reset_color%}"

	if [ "$SHOW_GIT" = "TRUE" ] && [ "$HIDE_GIT" != "TRUE" ]
	then
		echo -n "$(git_prompt_info)"
	fi
	echo -n "  "
}


# Virtual env
prompt_virtualenv() {
	ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[green]%}$VENV_PREFIX_ICON"
	ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="$VENV_SUFFIX_ICON %{$reset_color%}"
	ZSH_THEME_VIRTUALENV_PREFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX"
	ZSH_THEME_VIRTUALENV_SUFFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"

	echo -n "$(virtualenv_prompt_info)  "
}

# Ending shape and user symbol in new line
prompt_end() {
	echo ""
	echo -n "$PROMPT_END_ICON "
} 

# Create prompt string
build_prompt() {
	RETVAL=$?
	prompt_start
	prompt_status
	prompt_context
	prompt_dir
	prompt_git
	prompt_virtualenv
	prompt_end
}

# Show prompt
PROMPT='%{%f%b%k%}$(build_prompt)'
# Theme created from 'bira' and 'agnoster' themes
# Uses symbols from agnoster theme: #  ±  ➦ ✘ ⚡ ⚙
# And these, too: ▶


# Starting shape
prompt_start() {
	# echo -n "▶ "
	echo -n "➤ "
}

# Symbols (failed command, root and background jobs)
prompt_status() {
	local -a symbols
	
	[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
	[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
	[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"
	
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

# Git branch and working tree status
prompt_git() {
	if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]]; then
		if [[ "$(git rev-parse --symbolic-full-name HEAD 2> /dev/null)" = "HEAD" ]]; then
			ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}↪ "
		else
			ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}ᛘ "
		fi
	fi

	ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔"
	ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ±"
	ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[yellow]%}%{$reset_color%}"

	if [[ $SHOW_GIT = 'TRUE' ]];
	then
		echo -n "$(git_prompt_info)"
	fi
	echo -n "  "
}

# Virtual env
prompt_virtualenv() {
	ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[green]%}<"
	ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="> %{$reset_color%}"
	ZSH_THEME_VIRTUALENV_PREFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX"
	ZSH_THEME_VIRTUALENV_SUFFIX="$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"

	echo -n "$(virtualenv_prompt_info)  "
}

# Ending shape and user symbol in new line
prompt_end() {
	echo ""
	echo -n "$ "
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
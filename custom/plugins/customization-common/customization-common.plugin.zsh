function install-zsh-plugins() {
	echo -e "$CYAN➤ Installing autossuggestions plugin...$RESET"
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
	
	echo -e "\n$CYAN➤ Installing syntax-highlighting plugin...$RESET"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
	
	echo -e "\n$GREEN✓$RESET Plugins installed"
	
	echo -e "\n$CYAN➤ Enable plugins in .zshrc file...$RESET"
	nano $HOME/.zshrc

	echo -e "\n$GREEN✓$RESET Done"
}

function edit-path() {
	echo -e "$CYAN➤ Opening custom PATH file...$RESET"
	sudo nano /etc/paths.d/path

	echo -e "$CYAN➤ Applying changes to PATH file...$RESET"
	echo -e "$CYAN➤ Use "path" command to see the new PATH in different lines.$RESET"
	echo -e "$GREEN✓$RESET Done"
	exec zsh -l
}

function path(){
	echo $PATH | tr ':' '\n'
}

function show_git(){
	SHOW_GIT='TRUE'
}

function hide_git(){
	SHOW_GIT='FALSE'
}

function killport() {
	PID=`lsof -t -i:$1`
	echo -e "$RED➤ Killing process with PID $PID running on port $1...$RESET"
	kill $PID
	if [[ $? = 0 ]]; then
		echo -e "$GREEN✓$RESET Done"
	else
		echo -e "$RED✘$RESET Error"
	fi
}

# Zsh settings
alias config="code $SETTINGS_DIR"
alias ter="cd $SETTINGS_DIR"
alias bak="cd $BACKUP_DIR"
alias eenv="nano $HOME/.zshenv"
alias renv="source $HOME/.zshenv"
alias reload="zsh $SETTINGS_SCRIPT && source $HOME/.zshrc"
alias hist="nano $HOME/.zsh_history"
alias sg="show_git"
alias hg="hide_git"

# Hackers stuff
alias please="sudo "
alias bash="/bin/bash"
alias clear="printf '\33c\e[3J'"

# Misc
alias destroy="rm -rf"
alias cache="rm -r ~/.cache"
alias fonts="fc-cache -fv"
alias ok="exit"
# COLORS
RESET='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

# PATHS
SETTINGS_DIR="$HOME/Repos/TerminalSettings"
SETTINGS_SCRIPT="$SETTINGS_DIR/apply.zsh"

# SETTINGS
SHOW_GIT='TRUE'

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

# Variables
export EDITOR='nano'
export VISUAL="$EDITOR"

# Zsh settings
alias config="code $SETTINGS_DIR"
alias reload="zsh $SETTINGS_SCRIPT && source $HOME/.zshrc"
alias hist="nano $HOME/.zsh_history"
alias sg="show_git"
alias hg="hide_git"

# Hackers stuff
alias please="sudo "
alias bash="/bin/bash"

# Apps
alias kubectl="minikube kubectl --"

# Misc
alias destroy="rm -rf"
alias cache="rm -r ~/.cache"
alias fonts="fc-cache -fv"
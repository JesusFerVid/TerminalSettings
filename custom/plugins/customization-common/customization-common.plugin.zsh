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

# SETTINGS
SHOW_GIT='TRUE'

# DIRECTORIES
REPOS_DIR="$HOME/Repos"
SETTINGS_DIR="$REPOS_DIR/TerminalSettings"
SETTINGS_SCRIPT="$SETTINGS_DIR/apply.zsh"
BACKUP_DIR="$REPOS_DIR/BackupSettings"
AUTH_DIR="$HOME/.auth"
OBSIDIAN_DIR="$HOME/Obsidian Vaults"

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

function whousesport() {
	lsof -i :$1
}

# Ligaturize a font using Ligaturizer repository
# Receives the input font name, the output font name and the format.
function ligaturize() {
	local LIGATURIZER_DIR="$REPOS_DIR/Ligaturizer"
	declare -a VARIANTS=(Thin ThinItalic Light LightItalic Regular Italic RegularItalic Medium MediumItalic SemiBold SemiboldItalic Bold BoldItalic Black BlackItalic)

	# &> /dev/null

	for VARIANT in "${VARIANTS[@]}"
	do
		if fontforge -lang py -script "$LIGATURIZER_DIR/ligaturize.py" "$LIGATURIZER_DIR/fonts/$1/$1-$VARIANT.$3" --output-dir="$LIGATURIZER_DIR/fonts/output/$1" --output-name="$2";
		then
			echo -e "$GREEN✓$RESET Created $2-$VARIANT.$3"
		fi
	done

}

# Vault sync for Obsidian settings
function vsync() {
    local source_vault="$OBSIDIAN_DIR/$1"
    local base_dir=$(dirname "$source_vault")
    local source_obsidian="$source_vault/.obsidian"

    if [ ! -d "$source_obsidian" ]; then
        echo -e "$RED✘$RESET Source is not an Obsidian vault"
        return 1
    fi

    find "$base_dir" -mindepth 1 -maxdepth 1 -type d | while read -r vault; do
        if [ "$vault" != "$source_vault" ] && [ -d "$vault/.obsidian" ]; then
            rsync -a --delete "$source_obsidian/" "$vault/.obsidian/"
            if [ $? -eq 0 ]; then
                echo -e "$GREEN✓$RESET Successfully synced settings to $vault"
            else
                echo -e "$RED✘$RESET Error syncing settings to $vault"
            fi
        fi
    done
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
alias cls="clear"

# Misc
alias destroy="rm -rf"
alias cache="rm -r ~/.cache"
alias fonts="fc-cache -fv"
alias ok="exit"
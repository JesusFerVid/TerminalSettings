#!/bin/zsh

# DIRECTORIES
OHMYZSH_DIR="$HOME/.oh-my-zsh"
GH_CONFIG_DIR="$HOME/.config/gh"
CURRENT_DIRECTORY=$(dirname -- $0)

# Uncomment for "verbose" version

# Colors
# RESET='\033[0m'
# GREEN='\033[0;32m'
# CYAN='\033[0;36m'

OS=$(echo $OSTYPE)

# echo -e "$CYAN➤ Copying home directory files...$RESET"
cp $CURRENT_DIRECTORY/.gitconfig $HOME
cp $CURRENT_DIRECTORY/.zshrc $HOME

if [[ $OS == darwin* ]];
then
	cp $CURRENT_DIRECTORY/.zprofile $HOME
fi

# echo -e "$GREEN✓$RESET Done."

# echo -e "$CYAN➤ Copying oh-my-zsh custom directory...$RESET"
cp -R $CURRENT_DIRECTORY/custom $OHMYZSH_DIR
# echo -e "$GREEN✓$RESET Done."

# echo -e "$CYAN➤ Refreshing to apply changes...$RESET"
source $HOME/.zshrc

# echo -e "$CYAN➤ Enabling plugins...$RESET"
case $OS in
	linux*)
		omz plugin enable customization-linux customization-wsl &> /dev/null
	;;
	darwin*)
		omz plugin enable customization-mac developer-tools pyenv &> /dev/null
	;;
	msys*)
		echo "Windows detected"
	;;
	*)
		echo "Unknown OS"
	;;
esac

#!/bin/zsh

# DIRECTORIES
OHMYZSH_DIR="$HOME/.oh-my-zsh"
CURRENT_DIRECTORY=`dirname -- $0`

# Uncomment for "verbose" version

# Colors
# RESET='\033[0m'
# GREEN='\033[0;32m'
# CYAN='\033[0;36m'

# echo -e "$CYAN➤ Copying home directory files...$RESET"
# TODO: ON DEMAND
cp $CURRENT_DIRECTORY/.gitconfig $HOME
cp $CURRENT_DIRECTORY/.zshrc $HOME
cp $CURRENT_DIRECTORY/.zprofile $HOME
# echo -e "$GREEN✓$RESET Done."

# echo -e "$CYAN➤ Copying oh-my-zsh custom directory...$RESET"
cp -R $CURRENT_DIRECTORY/custom $OHMYZSH_DIR
# echo -e "$GREEN✓$RESET Done."

# echo -e "$CYAN➤ Refreshing to apply changes...$RESET"

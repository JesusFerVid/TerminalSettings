source /etc/zsh_command_not_found

# Hackers stuff
alias editenv="sudo nano /etc/environment && sudo nano /etc/zsh/zshenv"
alias editgrub="sudo nano /etc/default/grub"

# Groups
alias adduser="sudo gpasswd -a"
alias adduserp="sudo usermod -g"
alias deluser="sudo gpasswd -d"

# Misc
alias repos="grep -rhE ^deb /etc/apt/sources.list*"
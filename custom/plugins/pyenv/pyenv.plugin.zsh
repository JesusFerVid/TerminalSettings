# eval "$(pyenv init --path)"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

function enable-pyenv() {
	echo '\n' >> $SETTINGS_DIR/.zprofile
	echo '# Pyenv' >> $SETTINGS_DIR/.zprofile
	echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $SETTINGS_DIR/.zprofile
	echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $SETTINGS_DIR/.zprofile
	echo 'eval "$(pyenv init -)"' >> $SETTINGS_DIR/.zprofile
	echo 'eval "$(pyenv init --path)"' >> $SETTINGS_DIR/.zprofile
}
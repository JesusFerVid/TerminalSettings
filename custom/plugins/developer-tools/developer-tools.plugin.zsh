CADENCE_DIR="$HOME/Repos/Docker/Cadence"

function cadence-get() {
	echo -e "$CYAN➤ Downloading Cadence files...$RESET"
	if wget -c https://raw.githubusercontent.com/uber/cadence/master/docker/docker-compose.yml &> /dev/null && wget -c https://raw.githubusercontent.com/uber/cadence/master/docker/prometheus/prometheus.yml &> /dev/null;
	then
		echo -e "$GREEN✓$RESET Download complete."
	else
		echo -e "$RED✘$RESET There was a problem downloading the files."
	fi

	echo -e "$CYAN➤ Moving files to $CADENCE_DIR...$RESET"
	mkdir -p $CADENCE_DIR
	mv docker-compose.yml prometheus.yml $CADENCE_DIR

	echo -e "$GREEN✓$RESET Done."
}

function cadence-start(){
	echo -e "$CYAN➤$RESET Starting Cadence server... "
	docker-compose -f $CADENCE_DIR/docker-compose.yml up
}
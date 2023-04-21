CADENCE_DIR="$HOME/Repos/Docker/Cadence"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/completion.zsh.inc'; fi

# Functions

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

function cadence-es-start(){
	echo -e "$CYAN➤$RESET Starting Cadence server with elasticsearch... "
	docker-compose -f $CADENCE_DIR/docker-compose-es.yml up
}

# Aliases

# Switch between dev and prod clusters
alias dev='kubectl config use-context gke_mm-k8s-dev-01_europe-west1_mm-k8s-dev-01'
alias prod='kubectl config use-context gke_mm-k8s-prod-01_europe-west1_mm-k8s-prod-01'


# Use kubectl on dev or prod clusters without changing context
alias kdev='kubectl --context=gke_mm-k8s-dev-01_europe-west1_mm-k8s-dev-01'
alias kprod='kubectl --context=gke_mm-k8s-prod-01_europe-west1_mm-k8s-prod-01'

# Shortcut to kubectl
alias k='kubectl'

# Change default namespace
# Usage: `ns my-namespace` and then `k get pods` will list pods on `my-namespace`
ns() { kubectl config set-context --current --namespace="$1" }
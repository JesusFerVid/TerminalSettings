CADENCE_DIR="$HOME/Repos/Docker/Cadence"
GCLOUD_DIR="$HOME/Applications/google-cloud-sdk"
MM_DIR="$HOME/Repos/MasMovil"

# The next line updates PATH for the Google Cloud SDK.
# if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/path.zsh.inc'; fi
source $GCLOUD_DIR/path.zsh.inc

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/completion.zsh.inc'; fi
source $GCLOUD_DIR/completion.zsh.inc

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

function cadence-start() {
	echo -e "$CYAN➤ Starting Cadence server...$RESET"
	docker-compose -f $CADENCE_DIR/docker-compose.yml up
}

function cadence-es-start() {
	echo -e "$CYAN➤ Starting Cadence server with elasticsearch...$RESET"
	docker-compose -f $CADENCE_DIR/docker-compose-es.yml up
}

function health() {
	local PORT="8080"

	if [[ $1 != "" ]]; then
		PORT=$1
	fi

	curl http://0.0.0.0:$PORT/health
}

function restart() {
	local NAMESPACE="provision-sta"

	if [[ $2 != "" ]]; then
		NAMESPACE=$2
	fi
	
	kubectl rollout restart deployment $1 -n $NAMESPACE
}

# Aliases
alias mm="hide_git && cd $MM_DIR/mm-monorepo"
alias kc="show_git && cd $MM_DIR/kubernetes-clusters"

# GCloud
# Switch between clusters
alias dev='kubectl config use-context gke_mm-k8s-dev-01_europe-west1_mm-k8s-dev-01'
alias dev-m='kubectl config use-context gke_mm-k8s-dev-01_europe-southwest1_mm-k8s-dev-eusw1-01'
alias dev2='kubectl config use-context gke_mm-k8s-dev-02_europe-west2_mm-k8s-dev-02'
alias sta='kubectl config use-context gke_mm-k8s-dev-01_europe-west1_mm-k8s-sta-01'
alias sta-m='kubectl config use-context gke_mm-k8s-dev-01_europe-southwest1_mm-k8s-sta-eusw1-01'
alias prod='kubectl config use-context gke_mm-k8s-prod-01_europe-west1_mm-k8s-prod-01'
alias prod-m='kubectl config use-context gke_mm-k8s-prod-01_europe-southwest1_mm-k8s-prod-eusw1-01'

# Use kubectl on dev or prod clusters without changing context
alias kdev='kubectl --context=gke_mm-k8s-dev-01_europe-west1_mm-k8s-dev-01'
alias kprod='kubectl --context=gke_mm-k8s-prod-01_europe-west1_mm-k8s-prod-01'

# Shortcut to kubectl
alias k='kubectl'
alias mk='minikube'

# Change default namespace
# Usage: `ns my-namespace` and then `k get pods` will list pods on `my-namespace`
ns() { kubectl config set-context --current --namespace="$1" }
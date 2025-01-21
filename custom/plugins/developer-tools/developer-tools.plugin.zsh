# The next line updates PATH for the Google Cloud SDK.
# if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/path.zsh.inc'; fi
source $GCLOUD_DIR/path.zsh.inc

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/j.fernandez.vidal/Applications/google-cloud-sdk/completion.zsh.inc'; fi
source $GCLOUD_DIR/completion.zsh.inc

# FUNCTIONS
# Decodes the passed arguments in base64
function b64() {
	for encoded in $@
	do
		echo `echo -n "$encoded" | base64 --decode`
	done
}

# Encodes the passed arguments in base64
function e64() {
	for decoded in $@
	do
		echo `echo -n "$decoded" | base64`
	done
}

function cadence-get() {
	echo -e "$CYAN➤ Cloning Cadence repository...$RESET"
	if gh repo clone uber/cadence $CADENCE_DIR;
	then
		echo -e "$GREEN✓$RESET Download complete."
		echo -e "${BLUE}i$RESET Files downloaded in '$CADENCE_DIR'."
	else
		echo -e "$RED✘$RESET There was a problem downloading the files."
	fi
}

function cadence-start() {
	echo -e "$CYAN➤ Starting Cadence server...$RESET"
	docker-compose -f $CADENCE_DIR/docker/docker-compose.yml up
}

function cadence-es-start() {
	echo -e "$CYAN➤ Starting Cadence server with elasticsearch...$RESET"
	docker-compose -f $CADENCE_DIR/docker/docker-compose-es.yml up
}

function health() {
	local PORT="8080"

	if [[ $1 != "" ]]; then
		PORT=$1
	fi

	curl http://0.0.0.0:$PORT/health
}

# Change default namespace
# Usage: `ns my-namespace` and then `k get pods` will list pods on `my-namespace`
function ns() {
	kubectl config set-context --current --namespace="$1"
}

# Change cluster. Receives environment as parameter.
function cluster() {
    local context_string

    case "$1" in
			dev) context_string="$K8S_CONTEXT_DEV" ;;
			sta) context_string="$K8S_CONTEXT_STA" ;;
      prod) context_string="$K8S_CONTEXT_PROD" ;;
      *) echo -e "$RED✘$RESET Unknown environment"; return 1 ;;
    esac

		if ! kubectl config use-context $context_string; then
			echo -e "$RED✘$RESET Error while switching context"
			return 1
	fi
}

# Check for pods
function pods() {
	kubectl get pods -n $1 -l app=$2
}

# Check deployed version of a pod
function version() {
	kubectl get rs -n $1 --selector=app=$2 --sort-by=.metadata.creationTimestamp -o jsonpath="{.items[-1].metadata.labels.version}"
}

# Restart a delployment
function restart() {	
	kubectl rollout restart deployment $2 -n $1
}

# Get service-account from specified cluster
function get-sa() {
	# ns()
	kubectl -n $1 get secrets authn.$1-sa -o=yaml | yq e '.data."authn-service-account.json"' | base64 -d > ~/.auth/authn-sa-$1.json
}

# Get access_token from specified cluster
function get-authn-token() {
	$MM_DIR/mm-monorepo/pkg/mas-stack/security/auth/serviceaccount-client/go/sa-client access-token -v -f ~/.auth/authn-sa-$1.json | tail -n 1
}

function validate-portabilities() {
	cd $HOME/Applications/PortabilityProcessor
	zsh validate.sh && code $VALIDATOR_DIR
	cd "$(cd - > /dev/null && pwd)"
}

# Aliases
alias mm="hide_git && cd $MM_DIR/mm-monorepo"
alias mmd="hide_git && cd $MM_DIR/mm-monorepo-debug"
alias kc="show_git && cd $MM_DIR/kubernetes-clusters"

# GCloud
# Switch between clusters
# gke_mm-k8s-dev-01_europe-southwest1_mm-k8s-sta-eusw1-01
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
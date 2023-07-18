REPOS_DIR="$HOME/Repos"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-11.jdk/Contents/Home"

function docker-start(){
	echo -e "$CYAN➤ Launching Docker daemon through minikube...$RESET"
	minikube start
	
	echo -e "\n$CYAN➤ Setting Docker to work with minikube...$RESET"
	eval $(minikube docker-env)
	sudo ex +g/docker.local/d -cwq /etc/hosts
	echo "$(minikube ip) docker.local" | sudo tee -a /etc/hosts > /dev/null

	echo -e "\n$CYAN➤ Freeing up resources...$RESET"
	minikube pause
	
	echo -e "\n$GREEN✓$RESET Done."
}

function docker-stop(){
	echo -e "$RED➤ Stopping Docker daemon through minikube...$RESET"
	minikube stop
	echo -e "\n$GREEN✓$RESET Done."
}

# Hackers stuff
alias pat="cat $REPOS_DIR/pat"
alias pat2="cat $REPOS_DIR/pat2"

alias health="curl http://0.0.0.0:8080/health" 

# GitHub
alias prt="code $REPOS_DIR/pr_template.md"
alias mct="cat $REPOS_DIR/pr_merge_commit_template.txt"
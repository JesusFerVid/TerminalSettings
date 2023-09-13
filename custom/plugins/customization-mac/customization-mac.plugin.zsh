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
alias pat="cat $AUTH_DIR/pat 2> /dev/null"
alias pat2="cat $AUTH_DIR/pat2 2> /dev/null"

# GitHub
alias prt="code $REPOS_DIR/pr_template.md"
alias mct="cat $REPOS_DIR/pr_merge_commit_template.txt"
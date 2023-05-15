#!/bin/bash

BRANCH_FILE='.git/gitflowbranches'

# ------------------------------ FUNCTIONS ------------------------------
# get git ignore
# Gets an oficial .gitignore file from github/gitignore
# Deletes possible .gitignore file if already exists
# Needs a parameter with the name of the gitignore file in the repositoty (for example, Android)
function ggi()
{
	echo -e "$CYAN➤ Getting oficial .gitignore file...$RESET"
	rm -f .gitignore
	if wget -c https://raw.githubusercontent.com/github/gitignore/main/$1.gitignore -O .gitignore &> /dev/null ;
	then
		echo -e "$GREEN✓$RESET Done"
	else
		echo -e "$RED✘$RESET The specified file does not exist"
	fi
}

# git init
# Initializes git, creates a commit for the gitignore only and then commits non-ignored files
function ginit()
{
	echo -e "$CYAN➤ Creating repository...$RESET"
	
	# Main branch name
	echo -en "  $LIGHTPURPLE?$RESET Please enter a name for main branch: $DARKGRAY(main)$RESET "
	read
	if [[ $REPLY = "" ]];
	then
		git init
	else
		git init -b $REPLY
	fi
	
	echo -e "\n$CYAN➤ Staging .gitignore file...$RESET"
	git add .gitignore
	echo -e "\n$CYAN➤ Commiting .gitignore file...$RESET"
	git commit -m "Added .gitignore"
	echo -e "\n$CYAN➤ Staging non-ignored files...$RESET"
	git add .
	echo -e "\n$CYAN➤ Creating initial commit...$RESET"
	git commit -m "Initial commit"
	echo -e "\n$GREEN✓$RESET Done"
}

# Deletes all git-related files and folders
function git-destroy()
{
	echo -e "$RED➤ Deleting repository...$RESET"
	rm -rf .git*
	echo -e "$GREEN✓$RESET Done"
}

# Sets aliases to quickly change accounts in gh CLI
function gh-aliases() {
	local CONFIG_DIR="$HOME/.config/gh"
	local CONFIG_FILE="$CONFIG_DIR/hosts.yml"
	local WORK_CONFIG="$CONFIG_DIR/hosts.work.yml"
	local CORPORATIVE_CONFIG="$CONFIG_DIR/hosts.corporative.yml"

	gh alias set --shell work "cp $WORK_CONFIG $CONFIG_FILE && gh auth status"
	gh alias set --shell corporative "cp $CORPORATIVE_CONFIG $CONFIG_FILE && gh auth status"
}

# Short, easy way to clone a repo from GitHub using the token of the logged account in gh CLI
function ghclone() {
	git clone "https://$(gh auth token)@github.com/$1.git"
}

# git flow print
# Prints branches names
function gfprint()
{
	echo -e "$CYAN➤ Getting branches names...$RESET"

	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local main=$(sed -n '1{p;q}' $branch_file)
	local develop=$(sed -n '2{p;q}' $branch_file)
	local feature=$(sed -n '3{p;q}' $branch_file)
	local release=$(sed -n '4{p;q}' $branch_file)
	local hotfix=$(sed -n '5{p;q}' $branch_file)

	echo -e "  $LIGHTPURPLE$RESET Main branch:$LIGHTPURPLE $main $RESET"
	echo -e "  $LIGHTBLUE$RESET Develop branch:$LIGHTBLUE $develop $RESET"
	echo -e "  $GREEN$RESET Feature branch:$GREEN $feature $RESET"
	echo -e "  $YELLOW$RESET Release branch:$YELLOW $release $RESET"
	echo -e "  $RED$RESET Hotfix branch:$RED $hotfix $RESET"
}

# git flow set
# Prompts the user for branches names and saves them to a file
function gfset()
{
	local file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"

	echo -e "$CYAN➤ Setting-up branches names...$RESET"
	
	# 1 Main branch
	# 1.1 Getting branch name from repo
	local main=$(git rev-parse --abbrev-ref HEAD)
	
	# 1.2 Continue
	echo -en "  $LIGHTPURPLE?$RESET Name for main branch: $DARKGRAY($main)$RESET "
	read
	if [[ $REPLY = "" ]];
	then
		echo "$main" > $file
	else
		echo "$REPLY" > $file
	fi
	
	# 2 Develop branch
	echo -en "  $LIGHTBLUE?$RESET Name for develop branch: $DARKGRAY(develop)$RESET "
	read
	if [[ $REPLY = "" ]];
	then
		echo "develop" >> $file
	else
		echo "$REPLY" >> $file
	fi

	# 3 Feature branch
	echo -en "  $GREEN?$RESET Name for feature branch: $DARKGRAY(feature)$RESET "
	read
	if [[ $REPLY = "" ]];
	then
		echo "feature" >> $file
	else
		echo "$REPLY" >> $file
	fi

	# 4 Release branch
	echo -en "  $YELLOW?$RESET Name for release branch: $DARKGRAY(release)$RESET "
	read
	if [[ $REPLY = "" ]];
	then
		echo "release" >> $file
	else
		echo "$REPLY" >> $file
	fi

	# 5 Hotfix branch
	echo -en "  $RED?$RESET Name for hotfix branch: $DARKGRAY(hotfix)$RESET "
	read
	if [[ $REPLY = "" ]];
	then
		echo "hotfix" >> $file
	else
		echo "$REPLY" >> $file
	fi
	
	echo -e "$GREEN✓$RESET Done"
}

# git flow init
# Creates develop branch and switches to it
function gfi()
{
	echo -e "$CYAN➤ Initializing git flow...$RESET\n"
	gfset
	
	echo -e "\n$CYAN➤ Creating branches...$RESET"

	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local develop=$(sed -n '2{p;q}' $branch_file)
	
	git switch -qc $develop
	echo -e "$GREEN✓$RESET Done"
}

# git flow feature start
# Creates a feature/<feature_name> branch from develop and puts HEAD on new branch
function gffs()
{
	echo -e "$GREEN➤ Starting new feature...$RESET"
	
	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local develop=$(sed -n '2{p;q}' $branch_file)
	local feature=$(sed -n '3{p;q}' $branch_file)

	git switch -q $develop
	git switch -c $feature/$1
	echo -e "$GREEN✓$RESET Done"
}

# git flow feature finish
# Merges current feature branch into develop branch.
# By default, it uses squash + commit. Passing -m will perfom normal merge.
# You can delete feature branch afterwards by passing -d
function gfff()
{
	local feature_branch=$(git rev-parse --abbrev-ref HEAD)
	local squash="true"
	local delete_branch="false"

	while getopts ":dm" flags;
	do
		case $flags in
			d) delete_branch="true";;
			m) squash="false";;
			:) echo -e "-$OPTARG flag requires an argument.";;
			*) echo -e "Unknown flag -$OPTARG.";;
		esac
	done

	echo -e "$GREEN➤ Finishing feature...$RESET"
	
	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local develop=$(sed -n '2{p;q}' $branch_file)

	echo -en "\n$GREEN➤ Merging $feature_branch into $develop.$RESET"
	git switch -q $develop
	if [[ $squash = "true" ]];
	then
		echo -e "$GREEN Using squash merge...$RESET"
		git merge --squash $feature_branch
		
		echo -e "\n$GREEN➤ Commiting changes...$RESET"
		git commit
	else
		echo -e "$GREEN Using normal merge...$RESET"
		git merge $feature_branch
	fi
	
	if [[ $delete_branch = "true" ]];
	then
		echo -e "\n$GREEN➤ Deleting branch...$RESET"
		git branch -D $feature_branch
	else
		echo -e "\n$GREEN➤ Branch $feature_branch was not deleted.$RESET"
	fi
	echo -e "\n$GREEN✓$RESET Successfully applied changes to $develop branch"
}

# git flow release start
# Creates a new branch release/<name> from the latest develop commit and changes to it
function gfrs()
{
	echo -e "$YELLOW➤ Starting new release...$RESET"
	
	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local develop=$(sed -n '2{p;q}' $branch_file)
	local release=$(sed -n '4{p;q}' $branch_file)

	git switch -q $develop
	git switch -c $release/$1
	echo -e "$GREEN✓$RESET Done"
}

# git flow release finish
# Merges current release branch into both main and develop
# You can create a normal or annotated tag by passing -t or -a
# You can delete release branch afterwards by passing -d
function gfrf()
{
	local release_branch=$(git rev-parse --abbrev-ref HEAD)
	local delete_branch="false"
	local tag="false"
	local annotated_tag="false"

	while getopts ":dta" flags;
	do
		case $flags in
			d) delete_branch="true";;
			t) tag="true";;
			a) annotated_tag="true";;
			:) echo -e "-$OPTARG flag requires an argument";;
			*) echo -e "Unknown flag -$OPTARG";;
		esac
	done

	echo -e "$YELLOW➤ Finishing release...$RESET"
	
	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local main=$(sed -n '1{p;q}' $branch_file)
	local develop=$(sed -n '2{p;q}' $branch_file)

	echo -e "\n$YELLOW➤ Merging $release_branch into $main...$RESET"
	git switch -q $main
	git merge $release_branch

	if [[ $annotated_tag = "true" ]];
	then
		echo -e "\n$YELLOW➤ Creating annotated tag for commit...$RESET"
		git tag -a $(cut -d/ -f2 <<< $release_branch)
	elif [[ $tag = "true" ]];
	then
		echo -e "\n$YELLOW➤ Creating lightweight tag for commit...$RESET"
		git tag $(cut -d/ -f2 <<< $release_branch)
	fi

	echo -e "\n$YELLOW➤ Merging $release_branch into $develop...$RESET"
	git switch -q $develop
	git merge $release_branch

	
	if [[ $delete_branch = "true" ]];
	then
		echo -e "\n$YELLOW➤ Deleting branch...$RESET"
		git branch -D $release_branch
	else
		echo -e "\n$YELLOW➤ Branch $release_branch was not deleted.$RESET"
	fi
	echo -e "\n$GREEN✓$RESET Successfully applied changes to $main and $develop branches"
}

# git flow hotfix start
# Creates a new branch hotfix/<name> from the latest develop and changes to it
function gfhs()
{
	echo -e "$RED➤ Starting new hotfix...$RESET"

	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local develop=$(sed -n '2{p;q}' $branch_file)
	local hotfix=$(sed -n '5{p;q}' $branch_file)
	
	git switch -q $develop
	git switch -c $hotfix/$1
	echo -e "$GREEN✓$RESET Done"
}

# git flow hotfix finish
# Merges current hotfix branch into both main and develop
# You can create a normal or annotated tag by passing -t or -a
# You can delete hotfix branch afterwards by passing -d
function gfhf()
{
	local hotfix_branch=$(git rev-parse --abbrev-ref HEAD)
	local delete_branch="false"
	local tag="false"
	local annotated_tag="false"

	while getopts ":dta" flags;
	do
		case $flags in
			d) delete_branch="true";;
			t) tag="true";;
			a) annotated_tag="true";;
			:) echo -e "-$OPTARG flag requires an argument";;
			*) echo -e "Unknown flag -$OPTARG";;
		esac
	done

	echo -e "$RED➤ Finishing hotfix...$RESET"
	
	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local main=$(sed -n '1{p;q}' $branch_file)
	local develop=$(sed -n '2{p;q}' $branch_file)
	
	echo -e "\n$RED➤ Merging $hotfix_branch into $main...$RESET"
	git switch -q $main
	git merge $hotfix_branch

	if [[ $annotated_tag = "true" ]];
	then
		echo -e "\n$RED➤ Creating annotated tag for commit...$RESET"
		git tag -a $(cut -d/ -f2 <<< $hotfix_branch)
	elif [[ $tag = "true" ]];
	then
		echo -e "\n$RED➤ Creating lightweight tag for commit...$RESET"
		git tag $(cut -d/ -f2 <<< $hotfix_branch)
	fi
	
	echo -e "\n$RED➤ Merging $hotfix_branch into $develop...$RESET"
	git switch -q $develop
	git merge $hotfix_branch
	
	if [[ $delete_branch = "true" ]];
	then
		echo -e "\n$RED➤ Deleting branch...$RESET"
		git branch -D $hotfix_branch
	else
		echo -e "\n$RED➤ Branch $hotfix_branch was not deleted.$RESET"
	fi
	echo -e "\n$GREEN✓$RESET Successfully applied changes to $main and $develop branches"
}

# git flow pull
# Pulls both main and develop branches
function gfpull()
{
	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local main=$(sed -n '1{p;q}' $branch_file)
	local develop=$(sed -n '2{p;q}' $branch_file)

	echo -e "$CYAN➤ Pulling $main...$RESET"
	git switch $main
	git pull

	echo -e "\n$CYAN➤ Pulling $develop...$RESET"
	git switch $develop
	git pull

	echo -e "\n$GREEN✓$RESET Successfully pulled changes"
}

# git flow push
# Pushes both main and develop branches
function gfpush()
{
	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local main=$(sed -n '1{p;q}' $branch_file)
	local develop=$(sed -n '2{p;q}' $branch_file)
	
	echo -e "$CYAN➤ Pushing $main...$RESET"
	git switch $main
	git push
	
	echo -e "\n$CYAN➤ Pushing tags...$RESET"
	git push origin --tags
	
	echo -e "\n$CYAN➤ Pushing $develop...$RESET"
	git switch $develop
	git push
	
	echo -e "\n$GREEN✓$RESET Successfully pushed changes"
}

# git flow sync
# Pulls and pushes (syncs) both main and develop branches
function gfsync()
{
	echo -e "$CYAN➤ Quick sync...\n$RESET"
	gfpull
	echo -e ""
	gfpush
	echo -e "\n$GREEN✓$RESET Sync complete"
}

# git flow delete branches
# Deletes branches
# Pass -f -r -h for feature, release or hotfix branches
# Pass -a for all of them
function gfdb()
{
	echo -e "$CYAN➤ Cleaning up...$RESET"
	
	local branch_file="$(git rev-parse --show-toplevel)/$BRANCH_FILE"
	local main=$(sed -n '1{p;q}' $branch_file)
	local develop=$(sed -n '2{p;q}' $branch_file)
	local feature=$(sed -n '3{p;q}' $branch_file)
	local release=$(sed -n '4{p;q}' $branch_file)
	local hotfix=$(sed -n '5{p;q}' $branch_file)
	
	if [[ $1 = "-a" ]];
	then
		(git branch -D $(git branch | grep "$feature/*")) 2> /dev/null || echo -e "No feature branches left"
		(git branch -D $(git branch | grep "$release/*")) 2> /dev/null || echo -e "No release branches left"
		(git branch -D $(git branch | grep "$hotfix/*")) 2> /dev/null || echo -e "No hotfix branches left"
		echo -e "\n$GREEN✓$RESET Cleaning completed"
		return
	fi
	
	while getopts ":frh" flags;
	do
		case $flags in
			f) (git branch -D $(git branch | grep "$feature/*")) 2> /dev/null || echo -e "No feature branches left";;
			r) (git branch -D $(git branch | grep "$release/*")) 2> /dev/null || echo -e "No release branches left";;
			h) (git branch -D $(git branch | grep "$hotfix/*")) 2> /dev/null || echo -e "No hotfix branches left";;
			:) echo -e "-$OPTARG flag requires an argument";;
			*) echo -e "Unknown flag -$OPTARG";;
		esac
	done
	echo -e "\n$GREEN✓$RESET Cleaning completed"
}

# ------------------------------ ALIASES ------------------------------
alias gac="git add . && git commit"
alias gacm="git add . && git commit -m"
alias gs="git status"
alias gsm="git switch main"
alias gsd="git switch develop"
alias gt="git tree"

# Configuration for git
alias gci="git commit"
alias gcim="git commit -m"
alias gm="git merge"
alias gst="git status"
alias gco="git checkout"
alias gbr="git branch"
alias ga="git add"
alias gaa="ga -A"
alias gf="git fetch"
alias gd="git diff --word-diff=color"
alias gignore="git rm -r --cached .; git add ."
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gcop='git status | grep modified | awk "{print \$2}" | peco | xargs git checkout'
alias git_delete_local_branch='git branch --merged | grep -v "*" | grep -v master | grep -v for_tracking | xargs git branch -d'
alias git_delete_remote_branch="git branch -a --merged | grep -v master | grep remotes/origin| sed -e 's% *remotes/origin/%%' | xargs -I% git push origin :%"
alias gri="git rebase -i --autostash"
alias current-branch='git rev-parse --abbrev-ref HEAD'

function gl(){
	if [ $# -ne 0 ]; then
		git log --date=iso --pretty=format:'%h %Cgreen%ad %Cblue%an %Creset%s %C(blue)%d%Creset' $@
	else
		git log --date=iso --pretty=format:'%h %Cgreen%ad %Cblue%an %Creset%s %C(blue)%d%Creset' -10
	fi
}

# git push to current branch with remote fallback
function gp() {
	if [ $# -ne 0 ]; then
		# if origin is http://github.com/foo/bar, change to github.com:foo/bar
		if git remote | grep -q origin; then
			remote=`git config --get remote.origin.url`

			if echo $remote | grep -q "^https://"; then
				new_remote=`echo $remote | sed -e "s/https:\/\/github\.com\//github.com:/g"`

				git remote rm origin
				git remote add origin $new_remote
			fi
		fi

		# check whether remote mine exists or not
		mine_push=false
		for arg in $@; do
			if [ $arg = "mine" ]; then
				mine_push=true
			fi
		done

		# if mine does not exist, push to origin
		if $mine_push; then
			if git remote | grep -q mine; then
				git push $@ `current-branch`
			else
				git push `echo $@ | sed -e "s/mine/origin/"` `current-branch`
			fi
		else
			git push $@ `current-branch`
		fi
	else
		git push
	fi
}
function gpf() {
  current_dir=$(git rev-parse --show-toplevel)
  remote_url=$(git remote get-url --push origin)
  echo "\e[33m[Warning] You are trying force pushing\e[m"
  echo "  from: $current_dir:`current-branch`"
  echo "    to: $remote_url:`current-branch`"
  read Answer\?'Are you sure? [Y/n] '
  case $Answer in
    '' | [Yy]* )
      git push -f origin `current-branch`
      ;;
    * )
      echo "Force pushing interrupted."
      return 1
      ;;
  esac
}

function gg() {
	if [[ -n `git rev-parse --git-dir 2> /dev/null` ]]; then
		git grep -n $@
	else
		find . -type f | xargs grep -n --color=auto $@
	fi
}

function up() {
	git branch --set-upstream-to=$@/master master
}

function mine() {
	if [[ -n `git remote | grep mine` ]]; then
		echo "remote mine is already set up"
		return
	fi

	local repo_name=$(git rev-parse --show-toplevel | sed -e "s/^.*\///g")
	local repo_path="github.com:itkq/${repo_name}"
	git remote add mine $repo_path
	git fetch mine
	git branch --set-upstream-to=mine/`current-branch` `current-branch`
	echo "added remote mine: ${repo_name}"
}

# Apply proxy for titech pubnet
alias titech="git config --global http.proxy 131.112.125.238:3128"
alias untitech="git config --global --unset http.proxy"

# git-hook
# export PATH="$HOME/.git-hook/bin:$PATH"

function github-url() {
	ruby <<-EOS
		require 'uri'

		def parse_remote(remote_origin)
		  if remote_origin =~ /^(https|ssh):\/\//
		    uri = URI.parse(remote_origin)
		    [uri.host, uri.path]
		  elsif remote_origin =~ /^[^:\/]+:\/?[^:\/]+\/[^:\/]+$/
		    host, path = remote_origin.split(":")
		    [host.split("@").last, path]
		  else
		    raise "Not supported origin url: #{remote_origin}"
		  end
		end

		host, path = parse_remote(\`git config remote.origin.url\`.strip)
		puts "https://#{host}/#{path.gsub(/\.git$/, '')}"
	EOS
}

function preq() {
	# git rev-list --ancestry-path : only display commits that exist directly on the ancestry chain
	# git rev-list --first-parent  : follow only the first parent commit upon seeing a merge commit
	merge_commit=$(ruby -e 'print (File.readlines(ARGV[0]) & File.readlines(ARGV[1])).last' <(git rev-list --ancestry-path $1..master) <(git rev-list --first-parent $1..master))

	if git show $merge_commit | grep -q 'pull request'; then
		issue_number=$(git show $merge_commit | grep 'pull request' | ruby -ne 'puts $_.match(/#(\d+)/)[1]')
		url="$(github-url)/pull/${issue_number}"
	else
		url="$(github-url)/commit/${1}"
	fi

	if which open > /dev/null; then
		open $url
	else
		xdg-open $url
	fi
}

function private() {
	git config --local user.email takashikkbn@gmail.com
	git config --local user.name "Takashi Kokubun"
}

# ghe get
function ghe() {
	case $1 in
		get )
			# You must export $GHE_HOST in ~/.zshrc.local
			ghq get $GHE_HOST:$2
			;;
		* )
			ghq $@
			;;
	esac
}

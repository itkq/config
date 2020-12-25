# tmux
export PATH="$HOME/bin:$PATH"
alias tmux="tmux -2"
if [ -z "$TMUX" -a -z "$STY" ] && type tmux > /dev/null 2>&1; then
  tmux new-session -A -s "*scratch*"
fi

alias tma="tmux attach-session -t"
alias tml="tmux list-session"
alias tmr="tmux rename-session -t"
alias tmn="tmux new-session -s"
alias tmk="tmux kill-session -t"

function create-session() {
  if [ $# -ne 0 ]; then
    target_dir=$1
  else
    target_dir='.'
  fi
  target_dir=$(cd $target_dir; pwd)
  session_name=$(echo $target_dir | grep -o "[^/]*/[^/]*$" | sed -e "s/\./,/g")

  # switch or create session
  if tmux has-session -t $session_name > /dev/null 2>&1; then
    tmux switch-client -t $session_name
    return
  fi
  TMUX= tmux new-session -d -s $session_name -c $target_dir -n editor
  tmux switch-client -t $session_name

  tmux send-keys -t $session_name "clear" C-m
}
alias cs="create-session"

# rbenv
eval "$(rbenv init - --no-rehash zsh)"

# bundler
alias b="bundle"
alias be="bundle exec"

# bundle open
export BUNDLER_EDITOR="vim"

# rails
alias -g RET="RAILS_ENV=test"
alias -g RED="RAILS_ENV=development"
alias -g REP="RAILS_ENV=production"

# hash rocket
function hr() {
  sed -i '' -e 's/:\([a-zA-Z_]*\) =>/\1:/g' $1
}

export DISABLE_SPRING=1

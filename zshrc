source "$HOME/.aliases"

if [ -d "$HOME/.aliases.d" ]; then
  for file in $HOME/.aliases.d/*; do
    source $file
  done
fi

function powerline_precmd() {
  export PS1="$(~/.powerline-shell.py $? --shell zsh 2> /dev/null)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

install_powerline_precmd

export PATH="$HOME/bin:$PATH:$HOME/.rvm/bin"
export GPG_TTY=$(tty)

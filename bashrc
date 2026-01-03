export FZF_COMPLETION_TRIGGER='..'

eval "$(zoxide init bash)"
eval "$(starship init bash)"

if command -v zoxide &> /dev/null; then
  alias cd="zd"
  zd() {
    if [ $# -eq 0 ]; then
      builtin cd ~ && return
    elif [ -d "$1" ]; then
      builtin cd "$1"
    else
      z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
    fi
  }
fi

if command -v eza &> /dev/null; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'


DOT="$HOME/storage/shared/git/droidots"
alias dot="cd $DOT"
alias ep="nvim ~/.bashrc"
alias sour="source ~/.bashrc"
alias l="ls"
alias v="nvim"
alias q="exit"
alias c="clear"
alias gg="lazygit"
alias up="pkg update && pkg upgrade"
zo() {
  local selected_item

  selected_item=$(
    ls -a --group-directories-first |
      fzf \
        --layout=reverse \
        --height=90% \
        --header="$(pwd)" \
        --preview '
          if [ -d "{}" ]; then
            eza --color=always -T "{}"
          else
            bat --color=always --style=plain "{}" 2>/dev/null || file "{}"
          fi
        '
  )

  [[ -z "$selected_item" ]] && return

  if [[ -d "$selected_item" ]]; then
    cd "$selected_item" || return
    zo
  else
    xdg-open "$selected_item" >/dev/null 2>&1 &
  fi
}

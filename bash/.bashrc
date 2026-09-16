#
# ~/.bashrc
#

# Qt5 configuration for minimal WMs
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORM=xcb
export QT_STYLE_OVERRIDE=Fusion

# Alacritty 
export TERMINAL="alacritty"

# PI configuration
# Tell Pi to use your local Ollama server
export PI_API_BASE="http://localhost:11434/v1"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=20000

shopt -s histappend
shopt -s cmdhist

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# pnpm
export PNPM_HOME="/home/smitp/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
alias rosetta='python /home/smitp/unstop/Rosetta/rosetta.py'
export PATH="$HOME/.local/bin:$PATH"

# rote bundled runtimes (node, npm, npx, deno)
export PATH="$HOME/.rote/bin:$PATH"

# rote shell integration
[ -f ~/.rote/shell/init.sh ] && source ~/.rote/shell/init.sh

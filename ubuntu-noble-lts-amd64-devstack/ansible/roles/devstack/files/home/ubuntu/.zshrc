# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000000
SAVEHIST=1000000000

# konsole is dumb and not setting shell correctly
export SHELL=$(which zsh)

setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY
# End of lines configured by zsh-newuser-install

# Keybinds
#source ~/.zkbd/$TERM
bindkey -e
bindkey  "^[[1;3C" forward-word
bindkey  "^[[1;3D" backward-word
bindkey  "^[[1~"   beginning-of-line
bindkey  "^[[4~"   end-of-line

## IntelliJ terminal uses different things
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

# Local Path
export PATH=$PATH:$HOME/bin

# GO Paths
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Java Paths
# export JAVA_HOME=/etc/alternatives/jre

# SOPS
export SOPS_GCP_KMS_IDS=projects/rmb-lab/locations/global/keyRings/sops/cryptoKeys/sops-key

# Poetry
# export PYTHON_KEYRING_BACKEND=keyring.backends.fail.Keyring

source /etc/os-release

# Linux Brew System
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Completions
zstyle :compinstall filename '/home/rbelgrave/.zshrc'
FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

autoload -Uz compinit
compinit

# Z
. $(brew --prefix)/etc/profile.d/z.sh

# POWERLINE GO
function powerline_precmd() {
    PS1="$(powerline-go -mode patched -path-aliases "~/projects/github.com=P-GHUB" -modules shell-var,venv,ssh,cwd,perms,git,hg,docker,jobs,exit,root -error $? -shell zsh)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

# Editor
export EDITOR=/usr/bin/vim

# Set options
setopt HIST_IGNORE_DUPS # ignore duplication command history list
setopt hist_ignore_space # don't save commands beginning with spaces to history

# By default, ^S freezes terminal output and ^Q resumes it. Disable that so
# that those keys can be used for other things.
setopt no_flowcontrol

# show time a command took if over 4 sec
REPORTTIME=4
TIMEFMT="%*Es total, %U user, %S system, %P cpu"

# zyntac highlighting (this must always come last)
# . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

unset LESS PAGER MORE
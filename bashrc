#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable extended globbing
shopt -s extglob

# Stops from accidentally overwriting a file using >
set -o noclobber

# Fuzzy find utils
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash


########## Exports ##########
export LS_COLORS="$(vivid -m 8-bit generate solarized-dark)"
export EDITOR="micro"

export LUA_PATH='/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua;/usr/lib/lua/5.4/?.lua;/usr/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua;/home/conor/.luarocks/share/lua/5.4/?.lua;/home/conor/.luarocks/share/lua/5.4/?/init.lua'
export LUA_CPATH='/usr/lib/lua/5.4/?.so;/usr/lib/lua/5.4/loadall.so;./?.so;/home/conor/.luarocks/lib/lua/5.4/?.so'
export PATH='/home/conor/.luarocks/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl'


########## Aliases ##########
alias ls='ls -Ap --group-directories-first --color=auto'
alias py='python3'

page_man() {
    man "$1" | w3m
}

alias man=page_man


########## Prompts ###########

#PS1='[\u@\h \W]\$ '

FG_WHITE="$(tput setaf 15)"
BG_WHITE="$(tput setab 15)"

# 34 or 10 can't decide
FG_LGREEN="$(tput setaf 34)"
BG_LGREEN="$(tput setab 34)"

BG_GREEN="$(tput setab 22)"
FG_GREEN="$(tput setaf 22)"

BG_MGREEN="$(tput setab 28)"
FG_MGREEN="$(tput setaf 28)"

RESET="$(tput sgr0)"

if [[ $TERM == "rxvt-unicode-256color" ]]; then
    #export PS1="\[\033[38;5;15m\]\033[48;5;22m\] \u@\h \033[38;5;22m\]\033[48;5;28m\]\033[38;5;15m\] \W \033[38;5;28m\]\033[48;5;34m\]\033[38;5;15m\] \$ \033[38;5;34m\]\033[48;5;15m\]\[$(tput sgr0)\] \]"
    export PS1=$'\[${FG_WHITE}\]\[${BG_GREEN}\] \u@\h \[${FG_GREEN}\]\[${BG_MGREEN}\]\uE0B0\[${FG_WHITE}\] \W \[${FG_MGREEN}\]\[${BG_LGREEN}\]\uE0B0\[${FG_WHITE}\] \$ \[${FG_LGREEN}\]\[${BG_WHITE}\]\uE0B0\[${RESET}\] '
elif [[ $TERM != "linux" ]]; then
    export PS1=$'\[${FG_WHITE}\]\[${BG_GREEN}\][\u@\h \W]\$\[${RESET}\] '
fi

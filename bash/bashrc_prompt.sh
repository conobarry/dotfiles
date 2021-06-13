# ~/.bashrc_prompt
#

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

# tint_factor=50

# base_color='35;133;109' #23856d
# white='245;239;236' #f5efec
# black='27;25;24' #1b1918

# arrow=$'\uE0B0'
# reset='\[\033[0;00m\]'

if [[ $COLORTERM == "truecolor" ]]; then
    
    #export PS1="\[\033[38;5;15m\]\033[48;5;22m\] \u@\h \033[38;5;22m\]\033[48;5;28m\]\033[38;5;15m\] \W \033[38;5;28m\]\033[48;5;34m\]\033[38;5;15m\] \$ \033[38;5;34m\]\033[48;5;15m\]\[$(tput sgr0)\] \]"
    # export PS1=$'\[${FG_WHITE}\]\[${BG_GREEN}\] \u@\h \[${FG_GREEN}\]\[${BG_MGREEN}\]\uE0B0\[${FG_WHITE}\] \W \[${FG_MGREEN}\]\[${BG_LGREEN}\]\uE0B0\[${FG_WHITE}\] \$ \[${FG_LGREEN}\]\[${BG_WHITE}\]\uE0B0\[${RESET}\] '
    
    prompt_arr=()
    prompt_arr+=("\u@\h") # Username and hostname
    prompt_arr+=("\W") # Current directory
    prompt_arr+=("\\$") # $ or #
    
    PS1=$(python3 ~/.bash/bash_prompt.py --color 35 133 109 --black 27 25 24 --white 245 239 236 --tint 0.2 --items ${prompt_arr[@]})
    
else
    PS1=$'\[${FG_WHITE}\]\[${BG_GREEN}\][\u@\h \W]\$\[${RESET}\] '
fi

export PS1;

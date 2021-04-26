#!/usr/bin/env bash
#
# Script to enable, disable and toggle redshift on specific randr screens.
#
# Author:
#   Conor Barry

# TODO:
# - Currently, passing no screen numbers/names does not work as intended. When only one
#   parameter is passed, the script should loop over every randr screen but it only does
#   the first.


# Enables extended globbing
shopt -s extglob

# Location of the redshift configuration file to use
CONF_LOCATION="/home/conor/.config/redshift/redshift.conf"


# Constructs the part of the redshift command that specifies which screen to use.
# Arguments:
#   The screen number to use
# Outputs:
#   Writes the command part to stdout
function get_command_method() {

    local screen_num=$1

    case $screen_num in
        +([0-9]))
            echo "-m randr:crtc=$screen_num"
            ;;
        *)
            #error
            ;;
    esac
}


# Prints the usage information for this script
# Arguments:
#   None
# Outputs:
#   Writes usage text to stdout
function usage() {
    echo "usage: redshift {enable,disable,toggle} {screen_number,screen_name}"
}


# Returns the pid that matches the redshift instance running on the given screen number, or
#   null if one does not exist
function get_pid_from_screen_number() {
    local pid_cmd="pgrep -a redshift | grep 'crtc $1' | awk '{print \$1}'"
    local pid=$(pgrep -a redshift | grep "crtc $1" | awk '{print $1}')
    if [ -z "$pid" ] ; then
        echo null
    else
        echo "$pid"
    fi
}


# Starts redshift on the given screen number
function enable() {
    
    local screen_num=$1
    local screen_cmd=$(get_command_method $screen_num)

    printf "Enabling redshift on screen: $screen_num\n"

    enable_cmd="redshift -c $CONF_LOCATION $screen_cmd"
    $enable_cmd &
}

function enable_on_all_screens {

    local screen_numbers=$(get_all_screen_numbers)

    for num in ${screen_numbers[@]}; do
        enable "$num"
    done
}

# Kills the redshift process that is running on the specified screen
function disable() {

    local screen_num=$1
    local screen_cmd=$(get_command_method $screen_num)

    local kill_cmd=""
    local disable_cmd=""

    printf "Disabling redshift on screen: $screen_num\n"

    # case $screen_num in
    #     "all")
    #         kill_cmd="killall redshift"
    #         disable_cmd="redshift -x"
    #         ;;
    #     +([0-9]))
            local pid=$(get_pid_from_screen_number $screen_num)
            kill_cmd="kill -9 ${pid}"
            disable_cmd="redshift -x $screen_cmd"
    #         ;;
    #     *)
    #         #error
    #         ;;
    # esac

    $kill_cmd
    $disable_cmd
}

function toggle() {

    local screen_num=$1
    local screen_cmd=$(get_command_method $screen_num)

    # case $screen_num in
    #     "all")
    #         local result=$(pgrep redshift)

    #         # If there are no redshift processses running
    #         if [ -z "$result" ] ; then
    #             enable

    #         else
    #             disable
    #         fi
    #         ;;
    #     +([0-9]))
            local pid=$(get_pid_from_screen_number $screen_num)
            
            # If pid is null, there is no process running on this screen
            if [ $pid = null ] ; then
                enable $screen_num

            # Otherwise there is a process running on this screen
            else
                disable $screen_num
            fi
    #         ;;
    #     *)
    #         printf "Error: invalid argument to toggle(): $1\n"
    #         exit
    #         ;;
    # esac

}

# Returns the number of the screen whose name is the first argument to the function
#   If the name is invalid, returns null
get_screen_name_from_num() {
    screen_num=$(xrandr --listmonitors | grep "$1" | cut -c 2)
    if [ -z "$screen_num" ] ; then
        echo null
    fi
    echo $screen_num
}

# Returns true if the first argument is a valid screen number
check_screen_num() {
    if [ -z "$(xrandr --listmonitors | grep "$1:")" ] ; then
        echo false
    else
        echo true
    fi
}

# Returns an array of all screen numbers from xrandr
function get_all_screen_numbers() {

    local results_array=($(xrandr --listmonitors | cut -c 2))
    local screens_array=()

    for result in "${results_array[@]}"; do
        if [[ "$result" =~ [0-9]+ ]]; then
            screens_array+=("$result")
        fi
    done

    echo $screens_array

}


action=$1
screens_array=()

# Get rid of the first parameter
shift

# If there are any parameters left
if [ $# -gt 0 ] ; then

    # Store them in an array
    screens_array=( "$@" )    

# There are no more parameters, so the user wants to operate on all the screens
else

    screens_array=$(get_all_screen_numbers)

fi


for screen in ${screens_array[@]}; do

    screen_num=null

    case $screen in
        # If screen is a number, it's a screen number
        +([0-9]))

            # If the screen number is valid, keep it
            if [ $(check_screen_num $screen) = true ] ; then
                screen_num=$screen
            fi
            ;;
        
        # Otherwise it's the name of a screen
        *)
            # Get the number from the name and store it
            screen_num=$(get_screen_name_from_num $screen)
            ;;
    esac

    if [ $screen_num = null ] ; then
        printf "Invalid screen number or name: $2\n"
        usage
        exit
    fi

    case $action in
        "e" | "enable")
            enable "$screen_num"
            ;;
        
        "d" | "disable")
            disable "$screen_num"
            ;;
        
        "t" | "toggle")
            toggle "$screen_num"
            ;;

        *)
            printf "Invalid argument: $action\n"
            usage
            exit
            ;;
    esac

done




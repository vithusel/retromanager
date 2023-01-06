# Retro Manager © - 2023, https://vithuselservices.co.uk

# FUNCTIONS

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

# Whiptail auto-size
calc_wt_size() {
    WT_HEIGHT=17
    WT_WIDTH=$(tput cols)

    if [ -z "$WT_WIDTH" ] || [ "$WT_WIDTH" -lt 60 ]; then
        WT_WIDTH=80
    fi
    if [ "$WT_WIDTH" -gt 178 ]; then
        WT_WIDTH=120
    fi
    WT_MENU_HEIGHT=$((WT_HEIGHT-7))
    export WT_MENU_HEIGHT
}

msgbox() {whiptail --title "$1" --msgbox "$2" "$WT_HEIGHT" "$WT_WIDTH" 3>&1 1>&2 2>&3
}
# If script is running as root?
#
# Example:
# if is_root
# then
#     # do stuff
# else
#     print_text_in_color "$IRed" "You are not root..."
#     exit 1
# fi
#
is_root() {
    if [[ "$EUID" -ne 0 ]]
    then
        return 1
    else
        return 0
    fi
}

# Check if root
root_check() {
if ! is_root
then
    msg_box "Sorry, you are not root. You now have two options:"
 
"1. Use SUDO directly: ;
   a) :~$ sudo bash $SCRIPTS/name-of-script.sh ;
;
2. Become ROOT and then type your command:;
   a) :~$ sudo -i;
   b) :~# bash $SCRIPTS/name-of-script.sh;
;
In both cases above you can leave out $SCRIPTS/ if the script
is directly in your PATH.;

More information can be found here: https://unix.stackexchange.com/a/3064"
    exit 1
fi
}


# Retro Manager © - 2023, https://vithuselservices.co.uk

# FUNCTIONS

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
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
result=$(echo 
1. Use SUDO directly: ;
   a) :~$ sudo bash $SCRIPTS/name-of-script.sh ;
;
2. Become ROOT and then type your command:;
   a) :~$ sudo -i;
   b) :~# bash $SCRIPTS/name-of-script.sh;
;
In both cases above you can leave out $SCRIPTS/ if the script
is directly in your PATH.;

More information can be found here: https://unix.stackexchange.com/a/3064)
    exit 1
fi
}


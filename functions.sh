# Retro Manager © - 2023, https://vithuselservices.co.uk

# Centralised functions for repo

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

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

result=$(echo "Sorry, you are not root. You now have two options:

1. Use SUDO directly:
   a) :~$ sudo bash $SCRIPTS/name-of-script.sh

2. Become ROOT and then type your command:
   a) :~$ sudo -i
   b) :~# bash $SCRIPTS/name-of-script.sh

In both cases above you can leave out $SCRIPTS/ if the script
is directly in your PATH.

More information can be found here: https://unix.stackexchange.com/a/3064")
display_result "System Information"
    
fi
}
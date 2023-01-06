# Retro Manager © - 2023, https://vithuselservices.co.uk


# VARIABLES
#Get Script name and path
script_name=`basename $0`
script_path=$(dirname $(readlink -f $0))
script_path_with_name="$script_path/$script_name"
localip=($(hostname -I))
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

# FUNCTIONS

display_result() {
  dialog --title "$1" \
    --backtitle "Retro Manager © - 2023, https://vithuselservices.co.uk" \
    --no-collapse \
    --msgbox "$result" 0 0
}

display_tail() {
  dialog --title "$1" \
    --backtitle "Retro Manager © - 2023, https://vithuselservices.co.uk" \
    --tailboxbg "$result" 0 0 
}

# root test function
is_root() {
    if [[ "$EUID" -ne 0 ]]
    then
        return 1
    else
        return 0
    fi
}

# Current session user root check
root_check() {
if ! is_root
then

result=$(echo "Sorry, you are not root. You now have two options:

1. Use SUDO directly:
   a) :~$ sudo bash $script_path_with_name

2. Become ROOT and then type your command:
   a) :~$ sudo -i
   b) :~# bash $script_path_with_name

In both cases above you can leave out $script_path/ if the script
is directly in your PATH.

More information can be found here: https://unix.stackexchange.com/a/3064")
display_result "Elevate Script Privledge"
clear
exit 1
    
fi
}

#Check for os updates
os_update() {
result=$(apt update)
display_tail "Check for OS Updates"
}

# View availible Updates
view_update() {
result=$(apt list —upgradable)
display_tail "Availible Updates"
}

# Install Updates
install_update() {
result=$(apt upgrade -y)
display_tail "Installing Updates"
}
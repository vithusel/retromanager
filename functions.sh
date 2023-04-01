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
pendingupdates=`apt-get -q -y --ignore-hold --allow-change-held-packages --allow-unauthenticated -s dist-upgrade | /bin/grep  ^Inst | wc -l`

#Repo Variables
mainrepo=https://git.vithuselservices.co.uk/vithusel/retromanager.git

# FUNCTIONS

display_result() {
  dialog --title "$1" \
    --backtitle "Retro Manager © - 2023, https://vithuselservices.co.uk" \
    --no-collapse \
    --msgbox "$result" 0 0
}

display_consent() {
  dialog --title "Consent Screen" \
    --backtitle "Retro Manager © - 2023, https://vithuselservices.co.uk" \
    --no-collapse \
    --yesno "$consent" 7 60

# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
if [ "$response" == "0" ]; then
    echo "Accepted"
else
    echo "Consent Rejected"
    exit 1
fi
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

# Current session user root check
install_complete() {
result=$(echo "Install Complete

To run Retromanager please launch mainmenu.sh using the instructions below

1. Use SUDO directly:
   a) :~$ sudo bash $script_path/mainmenu.sh

2. Become ROOT and then type your command:
   a) :~$ sudo -i
   b) :~# bash $script_path/mainmenu.sh

In both cases above you can leave out $script_path/ if the script
is directly in your PATH.

More information can be found here: https://unix.stackexchange.com/a/3064")
display_result "Elevate Script Privledge"
clear
exit 1
}

# Install Updates
install_update() {
result=$(apt upgrade -y)
display_tail "Installing Updates"
}

# Install_if_not program
install_if_not() {
if ! dpkg-query -W -f='${Status}' "${1}" | grep -q "ok installed"
then
    apt-get update -q4 & apt-get install "${1}" -y
fi
}

clone_repo() {
    git clone $1
}

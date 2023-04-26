# Retro Manager © - 2023, https://vithuselservices.co.uk

# VARIABLES
script_name=`basename $0`
script_path=$(dirname $(readlink -f $0))
script_path_with_name="$script_path/$script_name"
localip=($(hostname -I))
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0
pendingupdates=`apt-get -q -y --ignore-hold --allow-change-held-packages --allow-unauthenticated -s dist-upgrade | /bin/grep  ^Inst | wc -l`
gofrprepo=https://api.github.com/repos/fatedier/frp/releases/latest
tmp=/tmp
backtitle="Retro Manager © - 2023, https://vithuselservices.co.uk"
mainrepo=https://git.vithuselservices.co.uk/vithusel/retromanager.git

# FUNCTIONS

display_result() {
  dialog --title "$1" \
    --backtitle $backtitle \
    --no-collapse \
    --msgbox "$result" 0 0
}

display_consent() {
  dialog --title "Consent Screen" \
    --backtitle $backtitle \
    --no-collapse \
    --yesno "$consent" 7 60


response=$?
if [ "$response" == "0" ]; then
    echo "Accepted"
else
    echo "Consent Rejected"
    exit 1
fi
}

display_apphostserver() {
  dialog --title "Application Install" \
    --backtitle $backtitle \
    --no-collapse \
    --yesno "$message" 7 60

response=$?
}

is_root() {
    if [[ "$EUID" -ne 0 ]]
    then
        return 1
    else
        return 0
    fi
}

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

install_update() {
result=$(apt upgrade -y)
display_tail "Installing Updates"
}

install_if_not() {
if ! dpkg-query -W -f='${Status}' "${1}" | grep -q "ok installed"
then
    apt-get update -q4 & apt-get install "${1}" -y
fi
}

clone_repo() {
    git clone $1
}

download_release() {
  spruce_type=$2
  download_url=$(curl -s $1 | jq -r ".assets[] | select(.name | test(\"${spruce_type}\")) | .browser_download_url")
  if [[ -z "$download_url" ]]; then
    echo "Error: no matching asset found for type $spruce_type"
    return 1
  fi
  wget -q -O $tmp/$3 $download_url
  if [[ $? -ne 0 ]]; then
    echo "Error: failed to download asset $download_url"
    return 1
  fi
  if [[ "$3" == *.tar.gz || "$3" == *.tgz ]]; then
    tar -zxf $tmp/$3 -C $tmp/
  elif [[ "$3" == *.zip ]]; then
    unzip -qq $tmp/$3 -d $tmp/
  else
    echo "Error: unknown file format for $3"
    return 1
  fi
}


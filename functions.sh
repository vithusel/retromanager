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
  package_name="$1"
  if ! dpkg-query -W -f='${Status}' "${package_name}" 2>/dev/null | grep -q "ok installed"; then
    echo "Installing ${package_name}..."
    if ! sudo apt-get update -qq && sudo apt-get install -y "${package_name}" 1>/dev/null; then
      echo "Failed to install ${package_name}. Exiting."
      exit 1
    fi
    echo "Successfully installed ${package_name}."
  else
    echo "${package_name} is already installed."
  fi
}


clone_repo() {
  if ! git clone $1; then
    dialog --title "Error" --msgbox "Failed to clone repository $1" 0 0
    return 1
  fi
}

download_release() {
  spruce_type=$2
  download_url=$(curl -s $1 | jq -r ".assets[] | select(.name | test(\"${spruce_type}\")) | .browser_download_url")
  if [[ -z "$download_url" ]]; then
    dialog --title "Error" --msgbox "No matching asset found for type $spruce_type" 0 0
    return 1
  fi
  filename=$(basename "$download_url")
  wget -q -O $tmp/$filename $download_url
  if [[ $? -ne 0 ]]; then
    dialog --title "Error" --msgbox "Failed to download asset $download_url" 0 0
    return 1
  fi
  if [[ "$filename" == *.tar.gz || "$filename" == *.tgz ]]; then
    tar -zxf $tmp/$filename -C $tmp/
  elif [[ "$filename" == *.zip ]]; then
    unzip -qq $tmp/$filename -d $tmp/
  else
    dialog --title "Error" --msgbox "Unknown file format for $filename" 0 0
    return 1
  fi
}



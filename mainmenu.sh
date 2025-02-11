#!/bin/bash
# Retro Manager © - 2023, https://vithuselservices.co.uk
source functions.sh

#Root Check
root_check

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Retro Manager © - 2023, https://vithuselservices.co.uk" \
    --title "Main Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 6 \
    "1" "System Information" \
    "2" "Update OS" \
    "3" "View Storage Usage" \
    "4" "Install Services/Applications" \
    "5" "System Service Management (LAMP)" \
    "6" "Update RetroManager" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    1 )
      result=$(echo "System Name: $HOSTNAME"; echo "Local IP: $localip"; uptime)
      display_result "System Information"
      ;;
    2 )
      chmod +x admin/osupdate.sh
      ./admin/osupdate.sh
      ;;
    3 )
      if [[ $(id -u) -eq 0 ]]; then
        result=$(du -sh /home/* 2> /dev/null; df -h 2> /dev/null)
        display_result "Home Space Utilization (All Users)"
      else
        result=$(du -sh $HOME 2> /dev/null; df -h 2> /dev/null)
        display_result "Home Space Utilization ($USER)"
      fi
      ;;
    4 )
      chmod +x admin/serviceinstall.sh
      ./admin/serviceinstall.sh
      ;;
    5 )
      result=$(echo "System Name: $HOSTNAME"; echo "Local IP: $localip"; uptime)
      display_result "System Information"
      ;;
    6 )
        result=$(echo RetroManager is about to update itself)
        display_result "RetroManager Update"
        git reset --hard
        git pull
        result=$(echo Update Complete)
        display_result "RetroManager Update"
      ;;
  esac
done
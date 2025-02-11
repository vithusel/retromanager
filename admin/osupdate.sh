#!/bin/bash

# Retro Manager © - 2023, https://vithuselservices.co.uk
source functions.sh

apt update

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Retro Manager © - 2023, https://vithuselservices.co.uk" \
    --title "Update OS" \
    --clear \
    --cancel-label "Back" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "C" "Check for update" \
    "U" "View Availible Updates" \
    "N" "Install Updates" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Going to main menu"
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    C )
      apt update
      ;;
    U )
      result=$(apt list --upgradable | awk -F/ '{print $1, $2}')
      display_result "Available Updates"
      ;;

    N )
      apt upgrade -y
      ;;
  esac
done
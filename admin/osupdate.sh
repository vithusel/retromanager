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
    --cancel-label "Exit" \
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
    C )
      apt update
      ;;
    U )
      result=$(echo "$pendingupdates")
      display_result "Availible Updates"
      ;;
    N )
      install_update
      ;;
  esac
done